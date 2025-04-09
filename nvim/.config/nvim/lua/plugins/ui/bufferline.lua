local buf_delete = function(n) Snacks.bufdelete(n) end

return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>bd', buf_delete, desc = 'Delete Buffer' },
    { '<leader>bD', '<Cmd>bd<CR>', desc = 'Delete Buffer' },
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Buffers to the Left' },
    { '<leader>bb', '<Cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
    { '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<Tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[b', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    { ']b', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
  },
  config = function()
    require('bufferline').setup({
      options = {
        close_command = buf_delete,
        right_mouse_command = buf_delete,
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
    })
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function() pcall(nvim_bufferline) end)
      end,
    })
  end,
}
