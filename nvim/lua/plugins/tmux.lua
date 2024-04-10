return {
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.keymap.set({ "n", "v" }, "<C-Left>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-Down>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-Up>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<C-Right>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
    end,
  },
  {
    "RyanMillerC/better-vim-tmux-resizer",
    config = function()
      vim.g.tmux_resizer_no_mappings = 1
      vim.g.tmux_resizer_resize_count = 4
      vim.g.tmux_resizer_vertical_resize_count = 8

      vim.keymap.set("n", "<M-Left>", ":TmuxResizeLeft<CR>", { silent = true })
      vim.keymap.set("n", "<M-Down>", ":TmuxResizeDown<CR>", { silent = true })
      vim.keymap.set("n", "<M-Up>", ":TmuxResizeUp<CR>", { silent = true })
      vim.keymap.set("n", "<M-Right>", ":TmuxResizeRight<CR>", { silent = true })

      vim.keymap.set("i", "<M-Left>", "<Esc>:TmuxResizeLeft<CR>i", { silent = true })
      vim.keymap.set("i", "<M-Down>", "<Esc>:TmuxResizeDown<CR>i", { silent = true })
      vim.keymap.set("i", "<M-Up>", "<Esc>:TmuxResizeUp<CR>i", { silent = true })
      vim.keymap.set("i", "<M-Right>", "<Esc>:TmuxResizeRight<CR>i", { silent = true })

      vim.keymap.set("v", "<M-Left>", ":<C-U>TmuxResizeLeft<CR>gv", { silent = true })
      vim.keymap.set("v", "<M-Down>", ":<C-U>TmuxResizeDown<CR>gv", { silent = true })
      vim.keymap.set("v", "<M-Up>", ":<C-U>TmuxResizeUp<CR>gv", { silent = true })
      vim.keymap.set("v", "<M-Right>", ":<C-U>TmuxResizeRight<CR>gv", { silent = true })
    end,
  },
}
