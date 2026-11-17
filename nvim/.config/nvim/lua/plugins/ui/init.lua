-- Colorscheme first so later plugins pick up its highlights.
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = { navic = { enabled = true } },
})
vim.cmd.colorscheme("catppuccin")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("plugins.ui.snacks")

require("util").tabline.setup()

require("plugins.ui.lualine")

require("nvim-navic").setup({ lsp = { auto_attach = true }, highlight = true })
require("incline").setup({
  -- Low zindex so pickers and popups draw over the tag.
  window = { margin = { vertical = 0, horizontal = 1 }, zindex = 10 },
  hide = { cursorline = true },
  render = require("util.incline").render,
})

require("tiny-cmdline").setup({
  position = { x = "50%", y = "20%" },
})
