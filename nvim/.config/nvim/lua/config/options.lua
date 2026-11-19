-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Clipboard
opt.clipboard = "unnamedplus"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Words
opt.iskeyword:append("-")

-- Line numbers and cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

-- Wrapping and scrolling
opt.wrap = false
opt.breakindent = true
opt.breakindentopt = "list:-1"
opt.whichwrap:append("<,>,[,]")
opt.scrolloff = 10
opt.sidescrolloff = 8

-- UI
opt.cmdheight = 0
opt.laststatus = 3
opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10
opt.showmatch = true
opt.matchtime = 2
opt.title = true
opt.fillchars:append({ diff = "╱" })

-- Search and completion
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Files and undo
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")

-- Timing
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Folds
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'util'.editor.foldexpr()"
opt.foldlevel = 99
