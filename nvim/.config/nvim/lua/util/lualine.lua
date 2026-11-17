-- Component builders for lualine; each returns something a lualine section accepts.
local M = {}

-- Nested list = equal priority, so the nearest folder with any marker wins.
local root_markers = { { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" } }

-- Oil buffers aren't files, so search from the directory they show.
local function root()
  return vim.fs.root(require("util.oil").dir(0) or 0, root_markers) or vim.fn.getcwd()
end

-- Wraps text in hl_group's fg/style, on the component's own section background.
local function format(component, text, hl_group)
  if not hl_group or hl_group == "" or text == "" then
    return text
  end
  component.hl_cache = component.hl_cache or {}
  local token = component.hl_cache[hl_group]
  if not token then
    local utils = require("lualine.utils.utils")
    local gui = {}
    for _, style in ipairs({ "bold", "italic" }) do
      if utils.extract_highlight_colors(hl_group, style) then
        table.insert(gui, style)
      end
    end
    token = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, hl_group)
    component.hl_cache[hl_group] = token
  end
  return component:format_hl(token) .. text .. component:get_default_hl()
end

-- Project root name, only when it differs from the cwd.
function M.root_dir()
  return function()
    local dir = root()
    return dir ~= vim.fn.getcwd() and vim.fs.basename(dir) or ""
  end
end

-- Path relative to the project root, keeping the last `length` parts (0 keeps all).
function M.pretty_path(opts)
  opts = vim.tbl_extend("force", { length = 3, directory_hl = "", filename_hl = "Bold" }, opts or {})
  return function(self)
    local path = require("util.oil").dir(0) or vim.api.nvim_buf_get_name(0)
    if path == "" then
      return ""
    end
    path = vim.fs.relpath(root(), path) or vim.fn.fnamemodify(path, ":~")
    local parts = vim.split(path, "/")
    if opts.length > 0 and #parts > opts.length then
      parts = { "…", unpack(parts, #parts - opts.length + 1) }
    end
    local filename = format(self, table.remove(parts), opts.filename_hl)
    local dir = #parts > 0 and format(self, table.concat(parts, "/") .. "/", opts.directory_hl) or ""
    return dir .. filename
  end
end

function M.macro_recording()
  return function()
    local reg = vim.fn.reg_recording()
    return reg ~= "" and "recording @" .. reg or ""
  end
end

return M
