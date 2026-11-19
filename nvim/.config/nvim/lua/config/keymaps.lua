local editor = require("util").editor
local map = vim.keymap.set

-- Registers: edits that don't yank. "0 holds the last yank only; deletes never overwrite it.
map("n", "x", '"_x', { desc = "Delete char (no yank)" })
map({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste last yank" })
map("n", "<leader>P", '"0P', { desc = "Paste last yank before" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change (no yank)" })
map({ "n", "x" }, "<leader>C", '"_C', { desc = "Change to end (no yank)" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete (no yank)" })
map({ "n", "x" }, "<leader>D", '"_D', { desc = "Delete to end (no yank)" })
map("n", "dd", function()
  return vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
end, { expr = true, desc = "Delete line (blank lines not yanked)" })
-- v makes b inclusive, so the char under the cursor goes too.
map("n", "dw", '"_dvb', { desc = "Delete word backwards (no yank)" })

-- Editing
map("x", "<", "<gv", { desc = "Dedent, keep selection" })
map("x", ">", ">gv", { desc = "Indent, keep selection" })
map("i", "<S-Tab>", "<C-d>", { desc = "Dedent" })
map("n", "J", "mzJ`z", { desc = "Join lines, keep cursor" })
map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below (no comment)" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above (no comment)" })
map("n", "<leader>*", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Comments (built-in gc)
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })
map("n", "gcA", editor.comment_at_eol, { desc = "Add comment at end of line" })

-- Home and End
map({ "n", "x" }, "<Home>", editor.smart_home, { expr = true, desc = "Smart home" })
map("i", "<Home>", function()
  return "<Cmd>normal! " .. editor.smart_home() .. "<CR>"
end, { expr = true, desc = "Smart home" })
map("o", "<Home>", "^", { desc = "First non-blank" })
map({ "n", "x" }, "<End>", function()
  return vim.wo.wrap and "g$" or "$"
end, { expr = true, desc = "End of line" })
-- g$ lands on the last character; <Right> moves past it so typing appends.
map("i", "<End>", function()
  return vim.wo.wrap and "<Cmd>normal! g$<CR><Right>" or "<End>"
end, { expr = true, desc = "End of line" })

-- Arrows: Up/Down follow screen lines when wrapped; a count still moves real lines.
for key, motion in pairs({ ["<Up>"] = "k", ["<Down>"] = "j" }) do
  map({ "n", "x" }, key, function()
    return vim.v.count == 0 and "g" .. motion or motion
  end, { expr = true, desc = "Screen line " .. motion })
  map("i", key, function()
    if vim.fn.pumvisible() == 1 or not vim.wo.wrap then
      return key
    end
    return "<Cmd>lua require('util').editor.insert_screen_move('" .. motion .. "')<CR>"
  end, { expr = true, desc = "Screen line " .. motion })
end

-- Scrolling and search: keep the cursor centered, open folds
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "<PageDown>", "<C-d>zzzv", { desc = "Half page down" })
map("n", "<PageUp>", "<C-u>zzzv", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next match" })
map("n", "N", "Nzzzv", { desc = "Prev match" })

-- Windows
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })

-- Tabs
map("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<Tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<cr>", { desc = "Prev tab" })

-- Buffers and files
map("n", "<leader>bo", editor.close_hidden_buffers, { desc = "Close hidden buffers" })
map("n", "<leader>W", "<cmd>noautocmd w<cr>", { desc = "Save without autocmds" })

-- Special copy
map({ "n", "x" }, "<leader>yf", editor.copy_path, { desc = "Copy relative path with line" })
map({ "n", "x" }, "<leader>yF", function()
  editor.copy_path(true)
end, { desc = "Copy absolute path with line" })
map("x", "<leader>yc", editor.copy_code_block, { desc = "Copy selection as code block" })
