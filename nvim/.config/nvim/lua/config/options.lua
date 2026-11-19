-- Set before any plugin loads so their <leader> maps pick it up.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.clipboard = "unnamedplus"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

opt.iskeyword:append("-")

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"

opt.cmdheight = 0
opt.laststatus = 3

opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10

opt.showmatch = true
opt.matchtime = 2

opt.title = true
opt.fillchars:append({ diff = "╱" })

opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")

opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

opt.splitbelow = true
opt.splitright = true

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'util'.editor.foldexpr()"
opt.foldlevel = 99
