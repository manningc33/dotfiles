return { -- autocompletion
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    -- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  },
  version = '1.*',
  opts = {
    keymap = {
      preset = 'default',
      ['<pageup>'] = { 'scroll_documentation_up', 'fallback' },
      ['<pagedown>'] = { 'scroll_documentation_down', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<M-Right>'] = { 'snippet_forward', 'fallback' },
      ['<M-Left>'] = { 'snippet_backward', 'fallback' },
      ['<Up>'] = { 'fallback' },
      ['<Down>'] = { 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      menu = {
        draw = { treesitter = { 'lsp' } },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    cmdline = {
      enabled = true,
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function(ctx) return vim.fn.getcmdtype() == ':' end,
        },
        ghost_text = { enabled = true },
      },
    },
    -- snippets = { preset = 'luasnip' },
  },
  opts_extend = { 'sources.default' },
}
