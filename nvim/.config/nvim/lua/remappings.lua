local keymap = vim.keymap
--keymap.set("n", "<Space>", "<Nop>", { desc = "make sure space doesn't do anything" })
vim.g.mapleader = " "

keymap.set({ "n", "v" }, "<C-u>", "<C-u>zzzv", { desc = "center C-u" })
keymap.set({ "n", "v" }, "<C-d>", "<C-d>zzzv", { desc = "center C-d" })
keymap.set({ "n", "v" }, "<PageUp>", "<C-u>zzzv", { desc = "PageUp = C-u" })
keymap.set({ "n", "v" }, "<PageDown>", "<C-d>zzzv", { desc = "PageDown = C-d" })

keymap.set("n", "n", "nzzzv", { desc = "center next find" })
keymap.set("n", "N", "Nzzzv", { desc = "center prev find" })

keymap.set("i", "<S-Tab>", "<C-d>", { desc = "shift-tab behaves normally in insert" })

keymap.set("n", "ge", "gF", { desc = "ge goes to file (and goes to line number)" })

-- better up/down
vim.keymap.set("n", "j", [[ v:count > 1 ? "m'" . v:count . "j" : "gj" ]], { expr = true, silent = true })
vim.keymap.set("n", "k", [[ v:count > 1 ? "m'" . v:count . "k" : "gk" ]], { expr = true, silent = true })

-- smart beginning and end of line
keymap.set({ "n", "v", "i" }, "<Home>", function()
  local column = vim.fn.col(".")
  vim.cmd("normal! ^")
  if column == vim.fn.col(".") then
    vim.cmd("normal! 0")
  end
end, { silent = true, desc = "go to start of line" })
keymap.set("o", "<Home>", "^", { desc = "go to start of line" })

-- better paste
vim.keymap.set("n", "<leader>p", function()
  vim.fn.setreg("+", vim.fn.getreg("+"), "V")
  vim.cmd("normal p")
end, { desc = "paste as lines" })

-- jump back to last position
--vim.keymap.set("n", "<bs>", "<c-o>", { desc = "jump backwards" })
--vim.keymap.set("n", "<s-bs>", "<c-i>", { desc = "jump forwards" })
vim.keymap.set("n", "gl", "`.", { desc = "goto to last change" })

-- move visual blocks
vim.keymap.set("n", "<M-Up>", "<cmd>m -2<CR>", { silent = true, desc = "move block up" })
vim.keymap.set("n", "<M-Down>", "<cmd>m +1<CR>", { silent = true, desc = "move block up" })
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "move block up" })
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "move block down" })

-- movement between buffers
vim.keymap.set("n", "<tab>", function()
  vim.cmd("bn")
end, { silent = true, desc = "go to next buffer" })
vim.keymap.set("n", "<s-tab>", function()
  vim.cmd("bp")
end, { silent = true, desc = "go to previous buffer" })

-- indent on insert in empty lines
vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { desc = "enter insert mode", expr = true })

-- no yank delete
vim.keymap.set("n", ")", '"_d', { desc = "delete without yanking" })
vim.keymap.set("n", "))", '"_dd', { desc = "delete line without yanking" })
vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { desc = "delete line", expr = true })
