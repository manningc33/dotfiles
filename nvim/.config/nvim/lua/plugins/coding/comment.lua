return { -- for special commenting, gco, gcO, gcA
  'numToStr/Comment.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  lazy = false,
  config = function()
    local comment = require('Comment')
    local ts_context_commentstring = require('ts_context_commentstring.integrations.comment_nvim')

    comment.setup({
      pre_hook = ts_context_commentstring.create_pre_hook(),
      mappings = {
        basic = vim.fn.has('nvim-0.10.0') == 0, -- basic is no longer necessary with neovim version 0.10.0
      },
    })
  end,
}
