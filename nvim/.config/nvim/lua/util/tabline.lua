local M = {}

-- ◢ and ◣: both edges slant outward going down, so each tab is a trapezoid.
local sep_left, sep_right = "\u{e0ba}", "\u{e0b8}"
local pad = "   "
local max_len, cut_len = 20, 17

local function set_highlights()
  -- Follows the configured catppuccin flavour.
  local c = require("catppuccin.palettes").get_palette()
  local hl = vim.api.nvim_set_hl
  hl(0, "TablineActive", { fg = c.crust, bg = c.blue, bold = true })
  hl(0, "TablineActiveSep", { fg = c.blue })
  hl(0, "TablineInactive", { fg = c.subtext0, bg = c.surface0 })
  hl(0, "TablineInactiveSep", { fg = c.surface0 })
  hl(0, "TabLineFill", {})
end

local function is_float(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

-- The tab's current window, unless it's a float (picker, popup); then the window it was entered from.
local function main_win(tab)
  local win = vim.api.nvim_tabpage_get_win(tab)
  if not is_float(win) then
    return win
  end
  local tabnr = vim.api.nvim_tabpage_get_number(tab)
  local prev = vim.fn.win_getid(vim.fn.tabpagewinnr(tabnr, "#"), tabnr)
  if prev ~= 0 and not is_float(prev) then
    return prev
  end
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if not is_float(w) then
      return w
    end
  end
  return win
end

local function label(tab)
  local buf = vim.api.nvim_win_get_buf(main_win(tab))
  local path = vim.api.nvim_buf_get_name(buf)
  local modified = vim.bo[buf].modified and "[+] " or ""
  local oil_dir = require("util.oil").label(buf, max_len, cut_len)

  if vim.bo[buf].buftype == "terminal" then
    return modified .. "[terminal]"
  elseif oil_dir then
    return modified .. oil_dir
  elseif path == "" then
    return modified .. "[no name]"
  end

  local name = vim.fn.fnamemodify(path, ":t")
  if vim.fn.strchars(name) > max_len then
    name = vim.fn.strcharpart(name, 0, cut_len) .. "…"
  end
  return modified .. MiniIcons.get("file", path) .. " " .. name
end

local function build()
  local current = vim.api.nvim_get_current_tabpage()
  local parts, widths, active = {}, {}, 1
  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local text = label(tab)
    local group = tab == current and "TablineActive" or "TablineInactive"
    active = tab == current and i or active
    widths[i] = vim.fn.strdisplaywidth(text) + #pad * 2 + 2
    -- %NT makes the tab clickable; %% escapes a literal % in file names.
    parts[i] = ("%%%dT%%#%sSep#%s%%#%s#%s%s%s%%#%sSep#%s"):format(
      vim.api.nvim_tabpage_get_number(tab),
      group,
      sep_left,
      group,
      pad,
      (text:gsub("%%", "%%%%")),
      pad,
      group,
      sep_right
    )
  end

  -- When the tabs don't fit, show the current one and as many neighbours as fit around it.
  local first, last, used = active, active, widths[active]
  local grew = true
  while grew do
    grew = false
    if last < #parts and used + widths[last + 1] <= vim.o.columns then
      last, used, grew = last + 1, used + widths[last + 1], true
    end
    if first > 1 and used + widths[first - 1] <= vim.o.columns then
      first, used, grew = first - 1, used + widths[first - 1], true
    end
  end

  return table.concat(parts, "", first, last) .. "%T%#TabLineFill#"
end

-- An error here would repeat on every redraw, so fall back to an empty bar.
function M.render()
  local ok, line = pcall(build)
  return ok and line or "%#TabLineFill#"
end

function M.setup()
  vim.o.showtabline = 1
  vim.o.tabline = "%!v:lua.require'util'.tabline.render()"
  set_highlights()

  local group = vim.api.nvim_create_augroup("util.tabline", { clear = true })
  -- :colorscheme clears custom groups, so re-apply them.
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
  -- Keep [+] in sync when a buffer is saved or changed.
  vim.api.nvim_create_autocmd("BufModifiedSet", { group = group, command = "redrawtabline" })
end

return M
