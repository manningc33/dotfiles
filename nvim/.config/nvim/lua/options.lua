local cmd = vim.cmd
local opt = vim.opt

opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.undofile = true
opt.wrap = false

-- ===== UI ===== --
opt.number = true -- show line number
opt.relativenumber = true -- show relative line number
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horizontal split below
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- ignore lowercase for the whole pattern
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.cursorline = true -- current line get highlighted
opt.smartindent = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.colorcolumn = "100"
opt.wrap = false
opt.swapfile = false
cmd("highlight ColorColumn ctermbg=1")

-- auto-resize splits when nvim gets resized
-- TODO: convert to lua LOL
cmd("autocmd VimResized * wincmd = ")

-- Last position on Document
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = vim.api.nvim_create_augroup("LastPosition", { clear = true }),
	callback = function()
		local test_line_data = vim.api.nvim_buf_get_mark(0, '"')
		local test_line = test_line_data[1]
		local last_line = vim.api.nvim_buf_line_count(0)

		if test_line > 0 and test_line <= last_line then
			vim.api.nvim_win_set_cursor(0, test_line_data)
		end
	end,
})
