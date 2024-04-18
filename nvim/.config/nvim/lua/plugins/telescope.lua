return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n",
        "\\",
        "<cmd>lua require'telescope.builtin'.find_files({find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }})<CR>",
        {desc = "file selector"}
      )
      vim.keymap.set("n", "<leader>f", builtin.live_grep, { desc = "find in all files" })
      vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "buffers selector" })

      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
        },
      })
    end,
  },
}
