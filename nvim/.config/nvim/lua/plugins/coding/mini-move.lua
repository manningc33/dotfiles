return {
  'echasnovski/mini.move',
  event = 'VeryLazy',
  opts = {
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-left>',
      right = '<M-right>',
      down = '<M-down>',
      up = '<M-up>',

      -- Move current line in Normal mode
      line_left = '<<',
      line_right = '>>',
      line_down = '<M-down>',
      line_up = '<M-up>',
    },
  },
}
