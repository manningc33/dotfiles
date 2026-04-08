return {
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    event = 'LazyFile',
  },
  {
    'nvim-mini/mini.hipatterns',
    event = 'LazyFile',
    config = function()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
          hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
          todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
          note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
