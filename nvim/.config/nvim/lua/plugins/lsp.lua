-- use mason-tool-installer to install non-lsp packages
-- use mason-lspconfig to install lsp packages
--
-- mason-tool-installer can technically install all mason packages, but mason-lspconfig provides nice names for lsp packages,
-- e.g. lua_ls not lua_language_server, or neocmake not neocmakelsp
--
-- Mason is just a tool installer
-- nvim-lspconfig created custom config function.
--  - sets custom keymaps for lsp
--  - configures lsp on top of configs provided by nvim-lspconfig
--  - enables lsp

return {
  {
    'mason-org/mason-lspconfig.nvim',
    -- mason-lspconfig will automatically install and enable ensure_installed
    opts_extend = { 'ensure_installed' },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'lua_ls',
      },
      automatic_enable = true,
    },
    dependencies = {
      {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        dependencies = {
          'WhoIsSethDaniel/mason-tool-installer.nvim',
          opts_extend = { 'ensure_installed' },
          event = 'LazyFile',
        },
        config = function(_, opts)
          require('mason').setup(opts)
          local mr = require('mason-registry')
          mr:on('package:install:success', function()
            vim.defer_fn(function()
              -- trigger FileType event to possibly load this newly installed LSP server
              require('lazy.core.handler.event').trigger({
                event = 'FileType',
                buf = vim.api.nvim_get_current_buf(),
              })
            end, 100)
          end)
        end,
      },
      {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
          servers = {
            ['*'] = { -- '*' server defines behavior for all LSPs
              capabilities = {
                workspace = {
                  fileOperations = {
                    didRename = true,
                    willRename = true,
                  },
                },
              },
              keys = {
                { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
                { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
                { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
                { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
                { 'gD', vim.lsp.buf.declaration, 'Goto Declaration' },
                { 'K', function() return vim.lsp.buf.hover() end, desc = 'Hover' },
                { 'gK', function() return vim.lsp.buf.signature_help() end, 'Signature Help' },
                { '<leader>ss', function() Snacks.picker.lsp_symbols() end, 'Document Symbol' },
                { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace Symbols' },
                { '<leader>rn', vim.lsp.buf.rename, 'Rename' },
                { '<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' } },
                { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
                { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
                { 'gai', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming' },
                { 'gao', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'C[a]lls Outgoing' },
              },
            },
          },
        },

        config = function(_, opts)
          for server, server_opts in pairs(opts.servers) do
            -- set keymaps
            if server_opts.keys then
              local Keys = require('lazy.core.handler.keys')

              for _, keys in pairs(Keys.resolve(server_opts.keys)) do
                local opts = Keys.opts(keys)
                opts.lsp = { name = server ~= '*' and server or nil }
                Snacks.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
              end
            end

            -- configure and then enable LSP
            vim.lsp.config(server, server_opts)
            if server ~= '*' then
              -- vim.lsp.enable(server)
            end
          end
        end,
      },
    },
  },
}
