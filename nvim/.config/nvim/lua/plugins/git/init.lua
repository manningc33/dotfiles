require("gitsigns").setup()

require("codediff").setup({
  diff = { compact = true, compact_context_lines = 8 },
  explorer = {
    view_mode = "tree",
    width = 50,
    auto_open_on_cursor = true,
    line_stats = { enabled = true },
  },
})

require("gitlinker").setup()
