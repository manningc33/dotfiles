local keymap = vim.keymap
--keymap.set("n", "<Space>", "<Nop>", { desc = "make sure space doesn't do anything" })
vim.g.mapleader = " "

-- better up/down
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

keymap.set({ "n", "v" }, "<C-u>", "<C-u>zzzv", { desc = "center C-u" })
keymap.set({ "n", "v" }, "<C-d>", "<C-d>zzzv", { desc = "center C-d" })
keymap.set({ "n", "v" }, "<PageUp>", "<C-u>zzzv", { desc = "PageUp = C-u" })
keymap.set({ "n", "v" }, "<PageDown>", "<C-d>zzzv", { desc = "PageDown = C-d" })

keymap.set("n", "n", "nzzzv", { desc = "center next find" })
keymap.set("n", "N", "Nzzzv", { desc = "center prev find" })

keymap.set("i", "<S-Tab>", "<C-d>", { desc = "shift-tab behaves normally in insert" })

keymap.set("n", "ge", "gF", { desc = "go to file under cursor" })

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
keymap.set("n", "<leader>p", function()
	vim.fn.setreg("+", vim.fn.getreg("+"), "V")
	vim.cmd("normal p")
end, { desc = "paste as lines" })

-- jump back to last position
--keymap.set("n", "<bs>", "<c-o>", { desc = "jump backwards" })
--keymap.set("n", "<s-bs>", "<c-i>", { desc = "jump forwards" })
keymap.set("n", "gl", "`.", { desc = "goto to last change" })

-- move visual blocks
keymap.set("n", "<M-Up>", "<cmd>m -2<CR>", { silent = true, desc = "move block up" })
keymap.set("n", "<M-Down>", "<cmd>m +1<CR>", { silent = true, desc = "move block up" })
keymap.set("i", "<M-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("i", "<M-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "move block up" })
keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "move block down" })

-- movement between buffers
keymap.set("n", "<tab>", "<cmd>bnext<cr>", { silent = true, desc = "go to next buffer" })
keymap.set("n", "<s-tab>", "<cmd>bprevious<cr>", { silent = true, desc = "go to previous buffer" })

-- windows 
keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- indent on insert in empty lines
keymap.set("n", "i", function()
	if #vim.fn.getline(".") == 0 then
		return [["_cc]]
	else
		return "i"
	end
end, { desc = "enter insert mode", expr = true })

-- no yank delete
keymap.set({ "n", "x" }, ")", '"_d', { desc = "delete without yanking" })
keymap.set("n", "))", '"_dd', { desc = "delete line without yanking" })
keymap.set("n", "dd", function()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	else
		return "dd"
	end
end, { desc = "delete line", expr = true })

-- better buffer delete 
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
keymap.set("n", "<leader>bd", function(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end, { desc = "Delete Buffer" })

-- lazy
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
