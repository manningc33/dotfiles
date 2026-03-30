return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'cmake' } },
  },
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        cmake = { 'cmakelint' },
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = { ensure_installed = { 'neocmake' } },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'cmakelang', 'cmakelint' } },
  },
}
