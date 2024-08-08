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

