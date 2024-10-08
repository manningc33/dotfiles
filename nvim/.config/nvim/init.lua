vim.g.loaded_netrw = 1
vim.g.loaded_netwrPlugin = 1

-- auto install lazy if not already present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("remappings")
require("autocmds")
require("lazy").setup({ import = "plugins" }, { change_detection = { notify = false } })
