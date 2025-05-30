return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = 'LazyFile',
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        -- c = { 'cpplint' },
        -- cpp = { 'cpplint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   dockerfile = { "hadolint" },
      --   bash = { "shellcheck" },
      --   c = { "cpplint" },
      --   cpp = { "cpplint" },
      --   tex = { "chktex" },
      --   python = { "ruff" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['rst'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
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
