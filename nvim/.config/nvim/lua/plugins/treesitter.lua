return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"comment",
				"cpp",
				"diff",
				"dockerfile",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"perl",
				"python",
				"query",
				"rust",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
			sync_install = false,

			highlight = { enable = true },
			indent = { enable = true },
			-- context_commentstring = { enable = true },
		})
	end,
}
