-- Counts how often keymaps (this config's and Neovim's defaults) and this config's autocmds fire, which
-- user commands get typed, filetypes opened, language servers attached, formatters run, and notifications
-- sent. Totals persist across sessions (and across Neovim instances running at once); `:UsageStats` lists
-- them with never-used entries last.
local M = {}

local file = vim.fn.stdpath("state") .. "/usage.json"
local config_dir = vim.fn.stdpath("config")
local self_src = debug.getinfo(1, "S").source
local kinds = { "keys", "commands", "filetypes", "servers", "formatters", "notifications", "autocmds" }
local maps = {} -- keymap id -> { mode, lhs, desc, file }
local autocmds = {} -- autocmd ids defined this session
local session = {} -- unsaved uses per kind: id -> { n, last }
local running = false
local default_src -- set while re-wrapping Neovim's default mappings

local function clear_session()
  for _, kind in ipairs(kinds) do
    session[kind] = {}
  end
end
clear_session()

local function read()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(file), "\n"))
  end)
  data = ok and type(data) == "table" and data or {}
  for _, kind in ipairs(kinds) do
    data[kind] = data[kind] or {}
  end
  data.since, data.sessions = data.since or os.date("%Y-%m-%d"), data.sessions or 0
  return data
end

local function bump(tbl, id)
  local entry = tbl[id] or { n = 0 }
  entry.n, entry.last = entry.n + 1, os.time()
  tbl[id] = entry
end

-- Adds the session's counts into `data`, keeping the latest last-used time.
local function merge(data)
  for _, kind in ipairs(kinds) do
    for id, e in pairs(session[kind]) do
      local cur = data[kind][id] or { n = 0, last = 0 }
      data[kind][id] = { n = cur.n + e.n, last = math.max(cur.last or 0, e.last) }
    end
  end
end

-- `source` relative to the config (e.g. "config/keymaps.lua"), or nil if it's outside it or this file.
local function config_path(source)
  if source ~= self_src and source:sub(2, #config_dir + 1) == config_dir then
    return (source:sub(#config_dir + 3):gsub("^lua/", ""))
  end
end

-- The config file that (directly or through a plugin) is setting the keymap, or nil for a plugin's own
-- internal keymaps, which aren't worth tracking.
local function config_file()
  for level = 3, 40 do
    local info = debug.getinfo(level, "S")
    if not info then
      return
    end
    local path = config_path(info.source)
    if path then
      return path
    end
  end
end

local function wrap_keymap_set()
  local set = vim.keymap.set
  vim.keymap.set = function(mode, lhs, rhs, opts)
    -- Keymaps a tracked keymap sets while running (e.g. oil's buffer keys) belong to the plugin.
    local src = default_src or (not running and config_file())
    -- An expr string is a Vimscript expression, and "" disables a key; leave both alone.
    if not src or (type(rhs) == "string" and (rhs == "" or (opts and opts.expr))) then
      return set(mode, lhs, rhs, opts)
    end
    opts = vim.tbl_extend("force", {}, opts or {})
    local modes = type(mode) == "table" and table.concat(mode) or mode
    local id = modes .. " " .. lhs
    maps[id] = { mode = modes, lhs = lhs, desc = opts.desc or "", file = src }

    local fn = rhs
    if type(rhs) == "string" then
      -- Returning the keys from an expr callback runs them as before.
      if opts.remap == nil and rhs:lower():match("^<plug>") then
        opts.remap = true
      end
      opts.expr = true
      fn = function()
        return rhs
      end
    end
    return set(mode, lhs, function(...)
      bump(session.keys, id)
      running = true
      local ok, res = pcall(fn, ...)
      running = false
      if not ok then
        error(res, 0)
      end
      return res
    end, opts)
  end
end

-- Only autocmds whose callback is written in this config; plugins' own stay untouched. They're named by
-- event and where the callback is defined, since most have no desc.
local function wrap_create_autocmd()
  local create = vim.api.nvim_create_autocmd
  vim.api.nvim_create_autocmd = function(event, opts)
    local cb = opts and opts.callback
    local info = type(cb) == "function" and debug.getinfo(cb, "S")
    local path = info and config_path(info.source)
    if not path then
      return create(event, opts)
    end
    local id = ("%s  %s:%d"):format(
      type(event) == "table" and table.concat(event, ",") or event,
      path,
      info.linedefined
    )
    autocmds[id] = true
    opts = vim.tbl_extend("force", {}, opts)
    opts.callback = function(...)
      bump(session.autocmds, id)
      return cb(...)
    end
    return create(event, opts)
  end
end

-- Other Neovim instances save to the same file. Holding a lock across read-add-write keeps one instance
-- from overwriting another's counts. Gives up after ~1s; the counts then go out with the next save.
local function with_lock(fn)
  local lock = file .. ".lock"
  for _ = 1, 50 do
    local fd = vim.uv.fs_open(lock, "wx", 420)
    if fd then
      vim.uv.fs_close(fd)
      local ok, err = pcall(fn)
      vim.uv.fs_unlink(lock)
      if not ok then
        error(err, 0)
      end
      return
    end
    -- A lock older than 10s was left by an instance killed mid-save.
    local stat = vim.uv.fs_stat(lock)
    if stat and os.time() - stat.mtime.sec > 10 then
      vim.uv.fs_unlink(lock)
    end
    vim.uv.sleep(20)
  end
end

-- Write then rename: a kill mid-write leaves the old file intact instead of a truncated one.
local function write(data)
  local tmp = file .. ".tmp"
  return vim.fn.writefile({ vim.json.encode(data) }, tmp) == 0 and vim.uv.fs_rename(tmp, file)
end

-- Notifications are read from Snacks' history, which records every vim.notify call. Snacks swaps vim.notify
-- in on first use, so a wrapper around it would miss them.
local last_notification = 0
local function count_notifications()
  local ok, history = pcall(function()
    return Snacks.notifier.get_history()
  end)
  local seen = last_notification
  for _, n in ipairs(ok and history or {}) do
    if n.id > seen then
      local msg = type(n.msg) == "string" and n.msg or ""
      local source = (n.title ~= "" and n.title) or msg:match("^([%w%-%._]+):") or "(untitled)"
      bump(session.notifications, n.level .. "  " .. source)
      last_notification = math.max(last_notification, n.id)
    end
  end
end

-- Adds the unsaved counts to the file, then clears them so the next save doesn't add them twice.
local function save(exiting)
  count_notifications()
  local pending = vim.iter(kinds):any(function(kind)
    return next(session[kind]) ~= nil
  end)
  if not exiting and not pending then
    return
  end
  vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
  with_lock(function()
    local data = read()
    merge(data)
    if exiting then
      data.sessions = data.sessions + 1
    end
    if write(data) then
      clear_session()
    end
  end)
end

local function ago(time)
  if not time then
    return "-"
  end
  local days = math.floor((os.time() - time) / 86400)
  return days == 0 and "today" or days .. "d ago"
end

-- Most-used first; `ids` defaults to everything recorded, and ids never used get a "Never used" heading.
local function section(lines, title, counts, ids, label)
  ids = ids or vim.tbl_keys(counts)
  table.sort(ids, function(a, b)
    local na, nb = (counts[a] or {}).n or 0, (counts[b] or {}).n or 0
    if na ~= nb then
      return na > nb
    end
    return a < b
  end)
  vim.list_extend(lines, { "", title })
  local unused = false
  for _, id in ipairs(ids) do
    local e = counts[id] or { n = 0 }
    if e.n == 0 and not unused then
      unused = true
      lines[#lines + 1] = "  Never used:"
    end
    lines[#lines + 1] = ("%6d  %-9s %s"):format(e.n, ago(e.last), label and label(id) or id)
  end
end

-- Report sections, in order; each name is also a `:UsageStats <name>` subcommand.
local sections = {
  {
    name = "keymaps",
    title = "Keymaps:",
    kind = "keys",
    -- Defaults this config later deletes (the gr* LSP keys) aren't keymaps anymore.
    ids = function()
      return vim.tbl_filter(function(id)
        local m = maps[id]
        return m.file ~= "(default)" or vim.fn.maparg(m.lhs, m.mode:sub(1, 1)) ~= ""
      end, vim.tbl_keys(maps))
    end,
    label = function(id)
      local m = maps[id]
      return ("%-4s %-20s %-36s %s"):format(m.mode, m.lhs, m.desc, m.file)
    end,
  },
  {
    name = "commands",
    title = "Commands typed:",
    kind = "commands",
    label = function(name)
      return ":" .. name
    end,
  },
  { name = "filetypes", title = "Filetypes opened:", kind = "filetypes" },
  {
    name = "servers",
    title = "Language servers attached:",
    kind = "servers",
    -- Enabled servers too, so one that never attaches shows up as never used.
    ids = function(counts)
      local ids = vim.tbl_keys(counts)
      for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
        if not counts[config.name] then
          ids[#ids + 1] = config.name
        end
      end
      return ids
    end,
  },
  { name = "formatters", title = "Formatters run:", kind = "formatters" },
  { name = "notifications", title = "Notifications by level and source:", kind = "notifications" },
  {
    name = "autocmds",
    title = "Config autocmds fired:",
    kind = "autocmds",
    ids = function()
      return vim.tbl_keys(autocmds)
    end,
  },
}

-- `only` limits the report to one section by name.
function M.report(only)
  count_notifications()
  local data = read()
  merge(data)

  local lines = {
    ("Usage since %s (%d sessions saved, plus this one)"):format(data.since, data.sessions),
    ("Stored in %s · saves on exit, focus loss, and every 5 min"):format(vim.fn.fnamemodify(file, ":~")),
  }
  for _, s in ipairs(sections) do
    if not only or s.name == only then
      section(lines, s.title, data[s.kind], s.ids and s.ids(data[s.kind]), s.label)
    end
  end

  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype, vim.bo[buf].bufhidden, vim.bo[buf].modifiable = "nofile", "wipe", false
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buf })
end

-- Clears one section's stats by name, or everything (including the "since" date) without one.
function M.reset(name)
  local kind
  if name then
    local s = vim.iter(sections):find(function(s)
      return s.name == name
    end)
    if not s then
      return vim.notify("UsageStats: unknown section " .. name, vim.log.levels.ERROR)
    end
    kind = s.kind
  end
  if vim.fn.confirm(("Reset %s usage stats?"):format(name or "all"), "&Yes\n&No", 2) ~= 1 then
    return
  end
  with_lock(function()
    if not kind then
      vim.fn.delete(file)
    elseif vim.fn.filereadable(file) == 1 then
      local data = read()
      data[kind] = {}
      write(data)
    end
  end)
  if kind then
    session[kind] = {}
  else
    clear_session()
  end
  vim.notify(("Usage stats reset (%s)"):format(name or "all"))
end

-- Must run before any keymap or autocmd is set.
function M.setup()
  wrap_keymap_set()
  wrap_create_autocmd()

  -- Neovim's default mappings (]d, gcc, gx...) exist before this config runs; re-set them so they're counted.
  default_src = "(default)"
  for _, mode in ipairs({ "n", "x", "o", "i" }) do
    for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
      if not m.lhs:match("^<Plug>") and (m.callback or m.expr == 0) then
        vim.keymap.set(mode, m.lhs, m.callback or m.rhs, {
          expr = m.expr == 1,
          remap = m.noremap == 0,
          silent = m.silent == 1,
          nowait = m.nowait == 1,
          desc = m.desc,
        })
      end
    end
  end
  default_src = nil

  local group = vim.api.nvim_create_augroup("util.usage", {})
  local function on(event, callback, pattern)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
  end

  on("VimLeavePre", function()
    save(true)
  end)
  -- Saving along the way means a killed session (closed terminal, tmux kill) loses at most 5 minutes.
  on("FocusLost", function()
    save()
  end)
  vim.uv.new_timer():start(300000, 300000, vim.schedule_wrap(save))

  on("CmdlineLeave", function()
    if vim.v.event.abort then
      return
    end
    -- User commands start uppercase; strip any range first ('<,'>GitLink).
    local name = vim.fn.getcmdline():gsub("^[%s:%d,.'<>$%%+-]*", ""):match("^%u%w*")
    if name and vim.api.nvim_get_commands({})[name] then
      bump(session.commands, name)
    end
  end, ":")
  -- Real files only, not plugin UI buffers (pickers, oil, which-key).
  on("FileType", function(ev)
    if vim.bo[ev.buf].buftype == "" then
      bump(session.filetypes, ev.match)
    end
  end)
  on("User", function(ev)
    bump(session.formatters, ev.data.formatter.name .. (ev.data.err and " (failed)" or ""))
  end, "ConformFormatPost")
  on("LspAttach", function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      bump(session.servers, client.name)
    end
  end)

  local subcommands = vim.tbl_map(function(s)
    return s.name
  end, sections)
  vim.api.nvim_create_user_command("UsageStats", function(cmd)
    local sub, arg = cmd.fargs[1], cmd.fargs[2]
    if sub == "reset" then
      M.reset(arg)
    elseif not sub or vim.tbl_contains(subcommands, sub) then
      M.report(sub)
    else
      vim.notify("UsageStats: unknown subcommand " .. sub, vim.log.levels.ERROR)
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      if line:match("reset%s") then
        return subcommands
      end
      return vim.list_extend(vim.deepcopy(subcommands), { "reset" })
    end,
    desc = "Usage report, all or one section; `reset [section]` clears stats",
  })
end

return M
