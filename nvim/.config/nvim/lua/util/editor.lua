local M = {}

-- First press goes to the first non-blank; pressed there, to column 0.
function M.smart_home()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local first = (vim.api.nvim_get_current_line():find("%S") or 1) - 1
  return col == first and "0" or "^"
end

-- Insert-mode gj/gk. Insert mode resets the wanted column after <Cmd>, so it's kept in w: vars to survive
-- repeated presses. gj reads curswant as the full virtual column, so the current screen row is added back.
-- normal! can't leave the cursor past the last character, so that's done by hand.
function M.insert_screen_move(motion)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local vcol = vim.fn.virtcol(".") - 1
  local last = vim.w.screen_move_pos
  local want = (last and last[1] == row and last[2] == col) and vim.w.screen_move_want or vcol

  local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local width = info.width - info.textoff
  vim.fn.winrestview({ curswant = vcol - vcol % width + want % width })
  vim.cmd("normal! g" .. motion)

  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local len = #vim.api.nvim_get_current_line()
  local row_start = vim.fn.virtcol({ r, c + 1 }) - 1
  row_start = row_start - row_start % width
  if c == len - 1 and row_start + want % width >= vim.fn.virtcol({ r, len }) then
    vim.api.nvim_win_set_cursor(0, { r, len })
  end

  vim.w.screen_move_pos = vim.api.nvim_win_get_cursor(0)
  vim.w.screen_move_want = want
end

-- Deletes listed buffers shown in no window (any tab); unsaved or undeletable ones are kept.
function M.close_hidden_buffers()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end

  local deleted, skipped = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and not visible[buf] then
      if not vim.bo[buf].modified and pcall(vim.api.nvim_buf_delete, buf, {}) then
        deleted = deleted + 1
      else
        skipped = skipped + 1
      end
    end
  end

  local msg = ("Deleted %d hidden buffer%s"):format(deleted, deleted == 1 and "" or "s")
  if skipped > 0 then
    msg = msg .. (" (%d kept)"):format(skipped)
  end
  vim.notify(msg)
end

return M
