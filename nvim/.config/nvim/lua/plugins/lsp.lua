local lsp_keymap_cb = function(event)
  -- Function to easily create LSP specific mappings
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
  map('gr', function() Snacks.picker.lsp_references() end, 'Goto References')
  map('gI', function() Snacks.picker.lsp_implementations() end, 'Goto Implementation')
  map('gy', function() Snacks.picker.lsp_type_definitions() end, 'Type Definition')
  map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
  map('gK', function() return vim.lsp.buf.signature_help() end, 'Signature Help')

  map('<leader>ss', function() Snacks.picker.lsp_symbols() end, 'Document Symbols')
  map('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace Symbols')
  map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
      end,
    })
  end
end

return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      { 'mason-org/mason-lspconfig.nvim', config = function() end },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    opts = {
      capabilities = {
        workspace = {
          fileOperations = { didRename = true, willRename = true },
        },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = lsp_keymap_cb,
      })

      -- combine capabilities
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('blink.cmp').get_lsp_capabilities(),
        opts.capabilities or {}
      )

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local servers = opts.servers
      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason-lspconfig').setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server)
            local server_opts =
              vim.tbl_deep_extend('force', { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
            if server_opts.enabled == false then
              return
            end

            -- server.capabilities = server_opts
            require('lspconfig')[server].setup(server_opts)
          end,
        },
      })
    end,
  },
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    opts_extend = { 'ensure_installed' },
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

      -- automatically install ensure_installed
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
