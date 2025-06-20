return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              diagnostics = { disable = { 'missing-fields' } },
              format = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
  {
    'mason-org/mason.nvim',
    opts = { ensure_installed = { 'stylua' }, },
  },
}
