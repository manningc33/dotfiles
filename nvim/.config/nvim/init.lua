require 'core.options'
require 'core.keymaps'
require 'core.autocmds'

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
    { import = 'plugins.ui' },
    { import = 'plugins.coding' },
    { import = 'plugins.editor' },
  },
  change_detection = { notify = false },
}
require('lazy').setup { import = 'plugins' } -- , { change_detection = { notify = false } })
-- require('lazy').setup({ import = 'plugins' }, { change_detection = { notify = false } })

-- require('lazy').setup {
--   require 'plugins.nvim-tree',
--   require 'plugins.colortheme',
--   require 'plugins.tmux',
--   require 'plugins.lualine',
--   require 'plugins.treesitter',
--   require 'plugins.telescope',
--   require 'plugins.lsp',
--   require 'plugins.formatting',
--   require 'plugins.lint',
--   require 'plugins.autocompletion',
--   require 'plugins.gitsigns',
--   require 'plugins.alpha',
--   require 'plugins.indent-blankline',
--   require 'plugins.oil',
--   require 'plugins.comments',
--   require 'plugins.autopairs',
--   require 'plugins.mini',
--   require 'plugins.misc',
--   require 'plugins.which-key',
--   require 'plugins.harpoon',
-- }
