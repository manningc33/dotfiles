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

-- navic only works on cursor events, nudge after server finishes loading
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("plugins.lsp", { clear = true }),
  pattern = "end",
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_exec_autocmds("CursorHold", { buffer = vim.api.nvim_get_current_buf() })
    end, 300)
  end,
})
