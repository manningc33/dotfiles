return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup()

			vim.keymap.set("n", "gp", gitsigns.preview_hunk, { desc = "preview hunk" })
			vim.keymap.set("n", "gb", gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
		end,
	},
}
