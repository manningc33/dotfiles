return {
  'akinsho/bufferline.nvim',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    }
  end,
}
