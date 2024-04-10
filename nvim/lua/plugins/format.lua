return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				html = { "prettierd" },
				css = { "prettierd" },
				json = { "prettier" },
				markdown = { "prettierd" },
				yaml = { "prettierd" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cmake = { "cmakelang" },
				tex = { "latexindent" },
				python = { "black" },

				javascript = { "prettierd" },
				typescript = { "prettierd" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "gf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
