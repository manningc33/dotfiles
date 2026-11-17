local gh = function(x)
  return "https://github.com/" .. x
end

vim.pack.add({
  -- ui
  gh("catppuccin/nvim"),
  gh("nvim-mini/mini.icons"),
  gh("rachartier/tiny-cmdline.nvim"),
  gh("nvim-lualine/lualine.nvim"),
})

require("plugins.ui")
