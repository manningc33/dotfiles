require("snacks").setup({
  notifier = { enabled = true },
  indent = { enabled = true, animate = { enabled = false } },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  picker = {
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
      buffers = { confirm = "drop" },
    },
  },
})
