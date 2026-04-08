return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { '<leader>ch', '<cmd>LspClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
          },
          root_markers = {
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac', -- AutoTools
            'Makefile',
            'configure.ac',
            'configure.in',
            'config.h.in',
            'meson.build',
            'meson_options.txt',
            'build.ninja',
            '.git',
          },
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        c = { 'cpplint' },
        cpp = { 'cpplint' },
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = { ensure_installed = { 'clangd' } },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'clang-format', 'cpplint' } },
  },
}
