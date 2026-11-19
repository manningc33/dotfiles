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
  gh("folke/which-key.nvim"),
  -- nav
  gh("stevearc/oil.nvim"),
  gh("folke/flash.nvim"),
  gh("mrjones2014/smart-splits.nvim"),
  gh("smart-splits-nvim/backend-tmux"),
  -- edit
  { src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
  gh("ribru17/blink-cmp-spell"),
  gh("moyiz/blink-emoji.nvim"),
  gh("windwp/nvim-autopairs"),
  gh("nvim-mini/mini.move"),
  gh("NMAC427/guess-indent.nvim"),
  gh("monaqa/dial.nvim"),
  -- git
  gh("lewis6991/gitsigns.nvim"),
  gh("esmuellert/codediff.nvim"),
  gh("linrongbin16/gitlinker.nvim"),
  -- lang
  gh("nvim-treesitter/nvim-treesitter"),
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("stevearc/conform.nvim"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("iamcco/markdown-preview.nvim"),
})

require("plugins.ui")
require("plugins.nav")
require("plugins.edit")
require("plugins.git")
require("plugins.lang")

require("plugins.keymaps")
