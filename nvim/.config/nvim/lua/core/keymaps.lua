-- helper function that defaults noremap and silent to true
local set_keymap = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent == nil and true or opts.silent
  opts.noremap = opts.noremap == nil and true or opts.noremap

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
-- set_keymap({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = false })

-- better up/down
set_keymap({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down' })
set_keymap({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up' })

-- Clear search with <esc>
set_keymap({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- save file without auto-formatting
set_keymap('n', '<leader>W', '<cmd>noautocmd w <CR>', { desc = 'Save without auto-formatting' })

-- delete single character without copying into register
set_keymap('n', 'x', '"_x')

-- shift tab behaves correctly
set_keymap('i', '<S-Tab>', '<C-d>', { desc = 'shift-tab behaves normally in insert' })

-- join line
set_keymap('n', 'J', 'mzJ`z', { desc = 'Join lines' })

-- smart beginning and end of line
set_keymap({ 'n', 'v', 'i' }, '<Home>', function()
  local column = vim.fn.col('.')
  vim.cmd('normal! ^')
  if column == vim.fn.col('.') then
    vim.cmd('normal! 0')
  end
end, { desc = 'go to start of line' })
set_keymap('o', '<Home>', '^', { desc = 'go to start of line' })

-- Vertical scroll and center
set_keymap({ 'n', 'v' }, '<C-d>', '<C-d>zz')
set_keymap({ 'n', 'v' }, '<C-u>', '<C-u>zz')
set_keymap({ 'n', 'v' }, '<PageUp>', '<C-u>zzzv', { desc = 'PageUp = C-u' })
set_keymap({ 'n', 'v' }, '<PageDown>', '<C-d>zzzv', { desc = 'PageDown = C-d' })

-- Find and center
set_keymap('n', 'n', 'nzzzv')
set_keymap('n', 'N', 'Nzzzv')

-- Windows
set_keymap('n', '<leader>w', '<c-w>', { desc = 'Windows', noremap = false })
set_keymap('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', noremap = false })
set_keymap('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', noremap = false })
set_keymap('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', noremap = false })

-- Tabs
set_keymap('n', '<leader>to', ':tabnew<CR>') -- open new tab
set_keymap('n', '<leader>tx', ':tabclose<CR>') -- close current tab
set_keymap('n', '<leader>tn', ':tabn<CR>') --  go to next tab
set_keymap('n', '<leader>tp', ':tabp<CR>') --  go to previous tab

-- Toggle line wrapping
set_keymap('n', '<leader>lw', '<cmd>set wrap!<CR>')

-- Stay in indent mode
set_keymap('v', '<', '<gv')
set_keymap('v', '>', '>gv')

-- Keep last yanked when pasting
-- set_keymap('v', 'p', '"_dP')

-- Delete without yanking
set_keymap({ 'n', 'x' }, ')', '"_d', { desc = 'delete without yanking' })
set_keymap('n', '))', '"_dd', { desc = 'delete line without yanking' })
set_keymap('n', 'dd', function()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return '"_dd'
  else
    return 'dd'
  end
end, { desc = 'delete line', expr = true })

-- search and replace word
set_keymap('n', '<leader>*', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'replace word' })
set_keymap('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Change file to executable' })

-- Diagnostic keymaps
set_keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set_keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set_keymap('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set_keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- lazy
set_keymap('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'Lazy' })
set_keymap('n', '<leader>lg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
