return {
  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<C-Left>', ':<C-U>TmuxNavigateLeft<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<C-Down>', ':<C-U>TmuxNavigateDown<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<C-Up>', ':<C-U>TmuxNavigateUp<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<C-Right>', ':<C-U>TmuxNavigateRight<CR>', { silent = true })
    end,
  },
  {
    'RyanMillerC/better-vim-tmux-resizer',
    config = function()
      vim.g.tmux_resizer_no_mappings = 1
      vim.g.tmux_resizer_resize_count = 4
      vim.g.tmux_resizer_vertical_resize_count = 8

      vim.keymap.set('n', '<S-Left>', ':TmuxResizeLeft<CR>', { silent = true })
      vim.keymap.set('n', '<S-Down>', ':TmuxResizeDown<CR>', { silent = true })
      vim.keymap.set('n', '<S-Up>', ':TmuxResizeUp<CR>', { silent = true })
      vim.keymap.set('n', '<S-Right>', ':TmuxResizeRight<CR>', { silent = true })

      vim.keymap.set('i', '<S-Left>', '<Esc>:TmuxResizeLeft<CR>i', { silent = true })
      vim.keymap.set('i', '<S-Down>', '<Esc>:TmuxResizeDown<CR>i', { silent = true })
      vim.keymap.set('i', '<S-Up>', '<Esc>:TmuxResizeUp<CR>i', { silent = true })
      vim.keymap.set('i', '<S-Right>', '<Esc>:TmuxResizeRight<CR>i', { silent = true })

      vim.keymap.set('v', '<S-Left>', ':<C-U>TmuxResizeLeft<CR>gv', { silent = true })
      vim.keymap.set('v', '<S-Down>', ':<C-U>TmuxResizeDown<CR>gv', { silent = true })
      vim.keymap.set('v', '<S-Up>', ':<C-U>TmuxResizeUp<CR>gv', { silent = true })
      vim.keymap.set('v', '<S-Right>', ':<C-U>TmuxResizeRight<CR>gv', { silent = true })
    end,
  },
}
