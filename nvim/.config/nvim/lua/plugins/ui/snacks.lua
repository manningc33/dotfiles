require("snacks").setup({
  notifier = { enabled = true },
  indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  lazygit = {
    theme = { activeBorderColor = { fg = "WarningMsg", bold = true } },
    -- `e` quits lazygit and opens the file in the window it was launched from (see util/git.lua).
    config = {
      os = {
        edit = require("util.git").lazygit_edit_command(),
        editAtLine = require("util.git").lazygit_edit_command(true),
      },
    },
  },
  picker = {
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
      buffers = { confirm = "drop" },
    },
  },
})
