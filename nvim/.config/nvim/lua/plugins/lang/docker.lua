return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'dockerfile' } },
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = { linters_by_ft = { dockerfile = { 'golangcilint' } } },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = { ensure_installed = { 'dockerls', 'docker_compose_language_service' } },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'hadolint', 'gofumpt', 'golangci-lint' } },
  },
}
