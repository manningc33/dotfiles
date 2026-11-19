return { -- autocompletion
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    'moyiz/blink-emoji.nvim',
    'Kaiser-Yang/blink-cmp-dictionary',
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
        -- columns = {
        --   { 'kind_icon' },
        --   { 'label', 'label_description', gap = 1 },
        --   { 'source_name' },
        -- },
        -- components = {
        --   source_name = {
        --     width = { max = 30 },
        --     text = function(ctx)
        --       -- Formats the text to look like "[LSP]" or "[Buffer]"
        --       return '[' .. ctx.source_name .. ']'
        --     end,
        --   },
        -- },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dictionary', 'emoji' },
      providers = {
        emoji = {
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 15, -- Tune by preference
          opts = {
            insert = true, -- Insert emoji (default) or complete its name
            trigger = function() return { ':' } end,
          },
          should_show_items = function() return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.o.filetype) end,
        },
        dictionary = {
          module = 'blink-cmp-dictionary',
          name = 'Dict',
          min_keyword_length = 1,
          opts = {
            force_fallback = true,
          },
        },
      },
    },
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
  },
  opts_extend = { 'sources.default' },
}
