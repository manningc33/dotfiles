return { -- addes additional substitute and exchange operators, another plugin that can do this is mini.operators
  'gbprod/substitute.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local substitute = require('substitute')

    substitute.setup()

    vim.keymap.set('n', '<leader>p', substitute.operator, { desc = 'Paste over' })
    vim.keymap.set('n', '<leader>pp', substitute.line, { desc = 'Paste over line' })
    vim.keymap.set('n', '<leader>P', substitute.eol, { desc = 'Paste over to end of line' })
    vim.keymap.set('x', '<leader>p', substitute.visual, { desc = 'Paste over' })

    vim.keymap.set('n', 'gx', require('substitute.exchange').operator, { noremap = true, desc = 'Exchange' })
    vim.keymap.set('n', 'gxx', require('substitute.exchange').line, { noremap = true, desc = 'Exchange line' })
    vim.keymap.set('x', 'gx', require('substitute.exchange').visual, { noremap = true, desc = 'Exchange' })
    vim.keymap.set('n', 'gxc', require('substitute.exchange').cancel, { noremap = true, desc = 'cancel exchange' })
  end,
}
