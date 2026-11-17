local M = {}

-- Absolute directory of an oil buffer (no trailing slash), or nil for any other buffer.
function M.dir(buf)
  if vim.bo[buf].filetype ~= "oil" then
    return nil
  end
  local dir = require("oil").get_current_dir(buf)
  return dir and (dir:gsub("(.)/$", "%1"))
end

-- "~/foo" for display; longer than max_len is cut from the left to "…" plus the last cut_len chars.
function M.label(buf, max_len, cut_len)
  local dir = M.dir(buf)
  if not dir then
    return nil
  end
  dir = vim.fn.fnamemodify(dir, ":~")
  local len = vim.fn.strchars(dir)
  if len > max_len then
    dir = "…" .. vim.fn.strcharpart(dir, len - cut_len)
  end
  return dir
end

return M
