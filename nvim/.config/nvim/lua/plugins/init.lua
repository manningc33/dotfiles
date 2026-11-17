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
})

require("plugins.ui")

require("plugins.keymaps")
