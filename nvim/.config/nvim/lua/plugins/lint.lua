return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = 'LazyFile',
    opts = {
      events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
      linters_by_ft = {},
    },
    config = function(_, opts)
      local lint = require('lint')
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          -- Only run the linter in buffers that you can modify in order to avoid superfluous noise
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
      vim.keymap.set('n', '<Leader>gl', function() lint.try_lint() end, { desc = 'Trigger linting for current file' })
    end,
  },
}
