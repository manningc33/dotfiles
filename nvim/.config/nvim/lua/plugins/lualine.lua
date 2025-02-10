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

    require('lualine').setup {
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
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = { { 'filename', newfile_status = true } },
        lualine_x = {
          {
            exchange,
            color = { fg = 'pink' },
          },
          { 'fileformat' },
          { 'encoding' },
          { 'filetype' },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {
        lualine_b = { { 'branch', color = { fg = '#b4befe' } } },
        lualine_c = { { 'buffers', mode = 2 } },
      },
      winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true } },
        lualine_x = { 'searchcount' },
      },
      inactive_winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true } },
      },
      extensions = { 'oil', 'nvim-tree', 'lazy', 'mason', 'man', 'quickfix' },
    }
  end,
}
