require("util.lang").use({
  parsers = { "markdown", "markdown_inline" },
  formatters = { markdown = { "markdownlint-cli2", "markdown-toc" } },
  servers = { "marksman" },
})

require("render-markdown").setup({
  code = { width = "block", right_pad = 1, language_border = " ", language_left = "", language_right = "" },
  sign = { enabled = false },
  completion = { lsp = { enabled = true } },
})

-- markdown-preview's `build`: its server is a prebuilt binary fetched after install and each update.
-- The install event fires before this file runs, so a missing binary is the install check.
if vim.fn.glob(vim.pack.get({ "markdown-preview.nvim" })[1].path .. "/app/bin/*") == "" then
  vim.fn["mkdp#util#install"]()
end
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("plugins.markdown", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == "markdown-preview.nvim" and ev.data.kind == "update" then
      vim.fn["mkdp#util#install"]()
    end
  end,
})
