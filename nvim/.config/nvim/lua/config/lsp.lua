vim.lsp.config("*", {
  capabilities = {
    workspace = { fileOperations = { didRename = true, willRename = true } },
  },
})

-- Server-specific keys: `keys` in after/lsp/<server>.lua, mapped where that server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    for _, key in ipairs(client.config.keys or {}) do
      vim.keymap.set(key.mode or "n", key[1], key[2], { buffer = ev.buf, desc = key.desc })
    end
  end,
})
