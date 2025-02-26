return {
  'SmiteshP/nvim-navic',
  opts = function()
    return {
      separator = ' ',
      highlight = true,
      depth_limit = 5,
      lazy_update_context = true,
      lsp = {
        auto_attach = true,
      },
    }
  end,
}
