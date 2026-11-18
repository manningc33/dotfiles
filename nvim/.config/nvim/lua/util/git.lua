local M = {}

-- Stages the buffer if it has unstaged changes, otherwise unstages it.
function M.toggle_stage_buffer()
  local status = vim.b.gitsigns_status_dict or {}
  local unstaged = (status.added or 0) + (status.changed or 0) + (status.removed or 0)
  if unstaged > 0 then
    require("gitsigns").stage_buffer()
  else
    require("gitsigns").reset_buffer_index()
  end
end

-- Opens the file as of the commit that last touched the cursor line, in a new tab, on that line.
-- Blames the buffer's current text, so unsaved edits don't shift the line; uses the commit's
-- file path, so renamed files still open.
function M.open_line_commit()
  local file = vim.api.nvim_buf_get_name(0)
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") .. "\n"
  local blame = vim
    .system({ "git", "blame", "--porcelain", "--contents", "-", "-L", vim.fn.line(".") .. ",+1", "--", file }, {
      cwd = vim.fs.dirname(file),
      stdin = text,
      text = true,
    })
    :wait()
  local sha, orig_lnum = blame.stdout:match("^(%x+) (%d+)")
  local path = blame.stdout:match("\nfilename ([^\n]+)")
  if blame.code ~= 0 or not sha then
    vim.notify("git blame failed: " .. vim.trim(blame.stderr), vim.log.levels.WARN)
    return
  elseif sha:match("^0+$") then
    vim.notify("This line isn't committed yet", vim.log.levels.WARN)
    return
  end
  require("gitsigns").show(sha .. ":" .. path, { open = "tabnew" }, function()
    vim.schedule(function()
      pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(orig_lnum), 0 })
      vim.cmd("normal! zz")
    end)
  end)
end

local lazygit_win

-- Opens lazygit, remembering the window so `e` can open files back in it.
function M.lazygit()
  lazygit_win = vim.api.nvim_get_current_win()
  Snacks.lazygit.open()
end

function M.lazygit_focus_origin()
  if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
    vim.api.nvim_set_current_win(lazygit_win)
  end
end

-- lazygit's os.edit / os.editAtLine (sh): quit lazygit, focus the launch window, open the file there.
function M.lazygit_edit_command(at_line)
  local server = 'nvim --server "$NVIM"'
  local inside = {
    server .. " --remote-send q",
    server .. [[ --remote-send "<Cmd>lua require('util.git').lazygit_focus_origin()<CR>"]],
    server .. " --remote {{filename}}",
  }
  if at_line then
    inside[#inside + 1] = server .. ' --remote-send ":{{line}}<CR>"'
  end
  local outside = at_line and "nvim +{{line}} -- {{filename}}" or "nvim -- {{filename}}"
  return ('if [ -z "$NVIM" ]; then %s; else %s; fi'):format(outside, table.concat(inside, "; "))
end

return M
