local group = vim.api.nvim_create_augroup("config", { clear = true })
local autocmd = function(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group }, opts))
end

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd("WinLeave", {
  callback = function()
    vim.wo.cursorline = false
  end,
})

autocmd("BufReadPost", {
  callback = function(ev)
    -- Runs before filetype detection, so 'filetype' is still empty here.
    if vim.filetype.match({ buf = ev.buf }) == "gitcommit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.bo.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
