local gh = function(x)
  return "https://github.com/" .. x
end

vim.pack.add({
  -- ui
  gh("catppuccin/nvim"),
  gh("nvim-mini/mini.icons"),
  gh("rachartier/tiny-cmdline.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("b0o/incline.nvim"),
  gh("SmiteshP/nvim-navic"),
  gh("folke/snacks.nvim"),
  -- nav
  gh("stevearc/oil.nvim"),
  -- lang
  gh("nvim-treesitter/nvim-treesitter"),
})

require("plugins.ui")
require("plugins.nav")
require("plugins.lang")

require("plugins.keymaps")
