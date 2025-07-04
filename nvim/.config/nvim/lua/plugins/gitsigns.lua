return {
  'lewis6991/gitsigns.nvim',
  event = 'LazyFile',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, 'Next Hunk')
      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, 'Prev Hunk')
      map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
      map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')
      map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
      map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
      map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo Stage Hunk')
      map('n', '<leader>gS', gs.stage_buffer, 'Stage Buffer')
      map('n', '<leader>gR', gs.reset_buffer, 'Reset Buffer')
      map('n', '<leader>gp', gs.preview_hunk_inline, 'Preview Hunk Inline')
      map('n', '<leader>gb', gs.toggle_current_line_blame, 'Toggle current line blame')
      map('n', '<leader>gB', function() gs.blame_line({ full = true }) end, 'Blame Line')
      map('n', '<leader>gd', gs.diffthis, 'Diff This')
      map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff This ~')
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
    end,
  },
}
