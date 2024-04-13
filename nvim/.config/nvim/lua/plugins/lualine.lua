return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				ignore_focus = { "NvimTree" },
			},
			sections = {
				lualine_b = { "branch" },
				lualine_c = { { "filename", path = 1 } },
			},
		})
	end,
}
