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

    vim.keymap.set('n', '(', require('substitute.exchange').operator, { noremap = true, desc = 'Exchange' })
    vim.keymap.set('n', '((', require('substitute.exchange').line, { noremap = true, desc = 'Exchange line' })
    vim.keymap.set('x', '(', require('substitute.exchange').visual, { noremap = true, desc = 'Exchange' })
    vim.keymap.set('n', '(c', require('substitute.exchange').cancel, { noremap = true, desc = 'cancel exchange' })
  end,
}
