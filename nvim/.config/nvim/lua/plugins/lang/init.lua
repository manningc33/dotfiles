require("plugins.lang.treesitter")

require("mason").setup()

require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(buf)
    if not (vim.g.disable_autoformat or vim.b[buf].disable_autoformat) then
      return { timeout_ms = 1000 }
    end
  end,
})
