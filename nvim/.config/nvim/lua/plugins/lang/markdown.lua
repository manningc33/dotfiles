return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters = {},
      formatters_by_ft = {
        ['markdown'] = { 'markdownlint-cli2', 'markdown-toc' },
        ['markdown.mdx'] = { 'markdownlint-cli2', 'markdown-toc' },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'markdownlint-cli2', 'markdown-toc' } },
  },
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        -- markdown = { 'markdownlint-cli2' },
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = { ensure_installed = { 'marksman' } },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      code = {
        language_border = ' ',
        language_left = '',
        language_right = '',
        width = 'block',
        right_pad = 1,
      },
      sign = { enabled = false },
      completion = { lsp = { enabled = true } },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      Snacks.toggle({
        name = 'Render Markdown',
        get = require('render-markdown').get,
        set = require('render-markdown').set,
      }):map('<leader>um')
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      {
        '<leader>cp',
        ft = 'markdown',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
      },
    },
    config = function() vim.cmd([[do FileType]]) end,
  },
}
