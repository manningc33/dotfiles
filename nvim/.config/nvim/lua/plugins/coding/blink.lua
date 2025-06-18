return { -- autocompletion
  'saghen/blink.cmp',
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = {
      preset = 'default',
      ['<esc>'] = { 'hide', 'fallback' },
      ['<pageup>'] = { 'scroll_documentation_up', 'fallback' },
      ['<pagedown>'] = { 'scroll_documentation_down', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<Up>'] = { 'fallback' },
      ['<Down>'] = { 'fallback' },
    },
    apperance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      accept = {
        auto_brakcets = { enabled = true },
      },
      menu = {
        draw = { treesitter = { 'lsp' } },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  },
  opts_extend = { 'sources.default' },
}
