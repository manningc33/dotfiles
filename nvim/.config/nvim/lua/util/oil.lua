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

-- Oil float with a preview, cursor on the current file. Opening the preview puts the cursor back on the first
-- entry, so it's moved once oil has drawn the listing.
function M.open_float()
  local name = vim.fn.expand("%:t")
  vim.api.nvim_create_autocmd("User", {
    pattern = "OilEnter",
    once = true,
    callback = function(ev)
      for lnum = 1, vim.api.nvim_buf_line_count(ev.data.buf) do
        local entry = require("oil").get_entry_on_line(ev.data.buf, lnum)
        if entry and entry.name == name then
          vim.api.nvim_win_set_cursor(0, { lnum, 0 })
          return
        end
      end
    end,
  })
  require("oil").open_float(nil, { preview = {} })
end

return M
