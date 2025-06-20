return {
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        cmake = { 'cmakelint' },
      },
    },
  },
  {
    'mason.nvim',
    opts = { ensure_installed = { 'cmakelang', 'cmakelint' } },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },
}
