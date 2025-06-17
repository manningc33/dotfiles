return {
  { -- for special commenting, gco, gcO, gcA
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    opts = {
      pre_hook = function() require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook() end,
    },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = { enable_autocmd = false },
  },
}
