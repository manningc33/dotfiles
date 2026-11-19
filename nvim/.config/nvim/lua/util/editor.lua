local M = {}

-- Filetypes treated as prose: wrap + spell, and spell/emoji completion.
M.prose_filetypes = { "text", "plaintex", "typst", "gitcommit", "markdown" }

-- First press goes to the first non-blank; pressed there, to column 0.
function M.smart_home()
  -- With wrap on, a continuation row has no indent: go to the start of that displayed row.
  if vim.wo.wrap then
    local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    if vim.fn.virtcol(".") > info.width - info.textoff then
      return "g0"
    end
  end
  local first = vim.api.nvim_get_current_line():find("%S")
  -- A blank line has no first non-blank; `^` would land on the last space.
  if not first or vim.api.nvim_win_get_cursor(0)[2] == first - 1 then
    return "0"
  end
  return "^"
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

-- Treesitter folds only where Treesitter runs. Fold state for other buffers (plugin scratch/preview) can
-- outlive them and error when a plugin later sets 'foldminlines' (codediff does).
function M.foldexpr()
  return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] and vim.treesitter.foldexpr() or "0"
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

-- Appends the buffer's comment marker at end of line and leaves you typing inside it.
function M.comment_at_eol()
  local left, right = vim.bo.commentstring:match("^(.-)%%s(.-)$")
  if not left then
    return
  end
  local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
  vim.api.nvim_set_current_line(line .. " " .. left .. right)
  if right == "" then
    vim.cmd("startinsert!")
  else
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line + 1 + #left })
    vim.cmd.startinsert()
  end
end

-- Copies the file's path (relative to cwd, or absolute) with `#L<line>` (or `#L<a>-L<b>` from visual
-- mode) for pasting into an agent.
function M.copy_path(absolute)
  local path = vim.fn.expand(absolute and "%:p" or "%:.")
  if path == "" then
    vim.notify("No file to copy", vim.log.levels.WARN)
    return
  end
  local first, last = vim.fn.line("."), vim.fn.line(".")
  if vim.fn.mode():match("[vV\22]") then
    first, last = math.min(vim.fn.line("v"), last), math.max(vim.fn.line("v"), last)
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  end
  local text = path .. "#L" .. first .. (last ~= first and "-L" .. last or "")
  vim.fn.setreg("+", text)
  vim.notify(text)
end

-- Copies the visual selection as a Markdown code block with Inkdrop-style `filename`/`line` attributes.
function M.copy_code_block()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local short = { typescriptreact = "tsx", javascriptreact = "jsx", typescript = "ts", javascript = "js" }
  local lang = short[vim.bo.filetype] or vim.bo.filetype
  local code = table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n")
  local text = ('```%s filename="%s" line=%d\n%s\n```'):format(lang, vim.fn.expand("%:."), first, code)
  vim.fn.setreg("+", text)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.notify(text)
end

return M
