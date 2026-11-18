vim.lsp.config("*", {
  capabilities = {
    workspace = { fileOperations = { didRename = true, willRename = true } },
  },
})

-- Diagnostics open with float
vim.diagnostic.config({
  jump = {
    on_jump = function(diagnostic, buf)
      if diagnostic then
        vim.diagnostic.open_float({ bufnr = buf, scope = "cursor" })
      end
    end,
  },
})
