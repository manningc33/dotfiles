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
  gh("folke/todo-comments.nvim"),
  gh("brenoprata10/nvim-highlight-colors"),
  -- nav
  gh("stevearc/oil.nvim"),
  gh("folke/flash.nvim"),
  gh("mrjones2014/smart-splits.nvim"),
  gh("smart-splits-nvim/backend-tmux"),
  -- lang
  gh("nvim-treesitter/nvim-treesitter"),
})

require("plugins.ui")
require("plugins.nav")
require("plugins.lang")

require("plugins.keymaps")
