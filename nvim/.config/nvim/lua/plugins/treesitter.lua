return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'comment',
      'cpp',
      'diff',
      'dockerfile',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'perl',
      'python',
      'query',
      'rust',
      'toml',
      'vim',
      'vimdoc',
      'yaml',
    },
    -- Autoinstall languages that are not installed
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
