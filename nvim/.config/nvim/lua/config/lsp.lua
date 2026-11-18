vim.lsp.config("*", {
  capabilities = {
    workspace = { fileOperations = { didRename = true, willRename = true } },
  },
})
