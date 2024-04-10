vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set({ "n", "v" }, "<C-u>", "<C-u>zzzv", { desc = "center C-u" })
keymap.set({ "n", "v" }, "<C-d>", "<C-d>zzzv", { desc = "center C-d" })
keymap.set({ "n", "v" }, "<PageUp>", "<C-u>zzzv", { desc = "PageUp = C-u" })
keymap.set({ "n", "v" }, "<PageDown>", "<C-d>zzzv", { desc = "PageDown = C-d" })

keymap.set("n", "n", "nzzzv", { desc = "center next find" })
keymap.set("n", "N", "Nzzzv", { desc = "center prev find" })

keymap.set("i", "<S-Tab>", "<C-d>", { desc = "shift-tab behaves normally in insert" })

keymap.set("n", "ge", "gF", { desc = "ge goes to file (and goes to line number)" })

local function ExtendedHome()
	local column = vim.fn.col(".")
	vim.cmd("normal! ^")
	if column == vim.fn.col(".") then
		vim.cmd("normal! 0")
	end
end

keymap.set({ "n", "v", "i" }, "<Home>", ExtendedHome, { silent = true })
