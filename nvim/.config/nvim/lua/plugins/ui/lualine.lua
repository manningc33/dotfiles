return {
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    opts = function()
      Snacks.toggle({
        name = 'navic',
        get = function() return not vim.g.navic_disable end,
        set = function(state) vim.g.navic_disable = not state end,
      }):map('<leader>un')
      return {
        separator = ' ',
        highlight = true,
        depth_limit = 5,
        lazy_update_context = true,
        lsp = {
          auto_attach = true,
        },
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        icons_enabled = true,
        -- theme = 'catppuccin',
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
            function()
              if vim.b.exchange_origin ~= nil then
                return [[ exchange in progress]]
              end
              return ''
            end,
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
        lualine_c = {
          { 'filename', path = 1 },
          {
            function() return require('nvim-navic').get_location() end,
            cond = function() return not vim.g.navic_disable and require('nvim-navic').is_available() end,
          },
        },
        lualine_x = { 'searchcount' },
      },
      inactive_winbar = {
        lualine_c = { { 'filename', path = 1, newfile_status = true } },
      },
      extensions = { 'oil', 'nvim-tree', 'lazy', 'mason', 'man', 'quickfix' },
    },
  },
}
