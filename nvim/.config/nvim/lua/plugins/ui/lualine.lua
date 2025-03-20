return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- function to detect substitute.nvim exchange mode
    local function exchange()
      if vim.b.exchange_origin ~= nil then
        return [[ exchange in progress]]
      end
      return ''
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        disabled_filetypes = {
          -- statusline = { "NvimTree" },
          -- winbar = { "NvimTree" },
        },
        ignore_focus = { 'NvimTree' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diagnostics' },
        lualine_c = { { 'filename', newfile_status = true } },
        lualine_x = {
          {
            exchange,
            color = { fg = 'pink' },
          },
          { 'diff' },
          { 'fileformat' },
          { 'encoding' },
          { 'filetype' },
        },
        lualine_y = { 'branch' },
        lualine_z = { { 'progress' }, { 'location' } },
      },
      winbar = {
        lualine_c = { { 'filename', path = 1 }, { 'navic', color_correction = 'dyanmic' } },
        lualine_x = { 'searchcount' },
      },
      inactive_winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true } },
      },
      extensions = { 'oil', 'nvim-tree', 'lazy', 'mason', 'man', 'quickfix' },
    })
  end,
}
