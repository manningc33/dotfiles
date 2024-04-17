return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        disabled_filetypes = {
          statusline = { "NvimTree" },
          winbar = { "NvimTree" },
        },
        ignore_focus = { "NvimTree" },
      },
      sections = {
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { { "filename", newfile_status = true } },
        lualine_x = { "fileformat", "filetype" },
      },
      tabline = {
        lualine_b = { { 'branch', color = { fg = "#b4befe" } } },
        lualine_c = { { 'buffers', mode = 2 } },
      },
      winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true, } },
        lualine_x = { "searchcount" }
      },
      inactive_winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true } },
      }
    })
  end,
}
