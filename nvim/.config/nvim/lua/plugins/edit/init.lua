require("plugins.edit.blink")

require("nvim-autopairs").setup({
  check_ts = true,
  fast_wrap = { keys = "arstneiowfpluycdvh" },
})

require("mini.move").setup({
  mappings = {
    left = "<M-Left>",
    right = "<M-Right>",
    down = "<M-Down>",
    up = "<M-Up>",
    line_left = "<<",
    line_right = ">>",
    line_down = "<M-Down>",
    line_up = "<M-Up>",
  },
})
