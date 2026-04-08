return {
  { 'mason-org/mason-lspconfig.nvim', opts = { ensure_installed = { 'jsonls', 'taplo', 'yamlls' } } },
  { 'nvim-treesitter/nvim-treesitter', opts = { ensure_installed = { 'json5', 'toml', 'yaml' } } },
  { 'b0o/SchemaStore.nvim', lazy = true },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = { json = { format = { enable = true }, validate = { enable = true } } },
        },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              'force',
              new_config.settings.yaml.schemas or {},
              require('schemastore').yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
            },
          },
        },
      },
    },
  },
}
