return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 500,
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
    },

    -- Document existing key chains
    spec = {
      { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[d]ocument' },
      { '<leader>r', group = '[r]ename' },
      { '<leader>f', group = '[f]ind/[f]iles' },
      { '<leader>g', group = '[g]it' },
      {
        '<leader>w',
        group = '[w]indows',
        proxy = '<c-w>',
        expand = function() return require('which-key.extras').expand.win() end,
      },
      {
        '<leader>b',
        group = '[b]uffers',
        expand = function() return require('which-key.extras').expand.buf() end,
      },
      { '<leader>s', group = '[s]earch' },
      { '<leader>u', group = '[u]i toggle' },
      { '[', group = 'prev' },
      { ']', group = 'next' },
      { 'gs', group = 'surruond' },
      { 'z', group = 'fold' },
    },
  },
  keys = {
    {
      '<leader>?',
      function() require('which-key').show({ global = false }) end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
