return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  config = function()
    local gitsigns = require 'gitsigns'
    gitsigns.setup()

    vim.keymap.set('n', 'gp', gitsigns.preview_hunk, { desc = 'preview hunk' })
    vim.keymap.set('n', 'gb', gitsigns.toggle_current_line_blame, { desc = 'toggle current line blame' })
  end,
}
