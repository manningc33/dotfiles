-- Colorscheme first so later plugins pick up its highlights.
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = { navic = { enabled = true }, which_key = true },
})
vim.cmd.colorscheme("catppuccin")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("plugins.ui.snacks")

require("util").tabline.setup()

require("plugins.ui.lualine")

require("nvim-navic").setup({ lsp = { auto_attach = true } })
vim.g.navic_disabled = true
require("incline").setup({
  -- Low zindex so pickers and popups draw over the tag.
  window = { margin = { vertical = 0, horizontal = 1 }, zindex = 10 },
  render = require("util.incline").render,
})

require("tiny-cmdline").setup({
  position = { x = "50%", y = "20%" },
  on_reposition = require("tiny-cmdline").adapters.blink,
})

require("todo-comments").setup()

vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({ enable_ansi = true })

require("which-key").setup({
  delay = 500,
  spec = {
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>l", group = "lsp/code", mode = { "n", "x" } },
    { "<leader>u", group = "toggle" },
    { "<leader>t", group = "tabs" },
    { "<leader>w", group = "windows", proxy = "<C-w>" },
    { "<leader>b", group = "buffers" },
    { "<leader>y", group = "special copy", mode = { "n", "x" } },
    { "gc", group = "comment" },
    { "[", group = "prev" },
    { "]", group = "next" },
    { "z", group = "fold" },
  },
})
