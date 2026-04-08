return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts_extend = { 'ensure_installed' },
  branch = 'main',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'comment',
      'cpp',
      'diff',
      'dockerfile',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'html',
      'json',
      'latex',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'regex',
      'rust',
      'vim',
      'vimdoc',
    },
  },
  config = function(_, opts)
    local ts = require('nvim-treesitter')
    ts.setup(opts)
    ts.install(opts.ensure_installed)

    local installed_parsers = ts.get_installed()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
      pattern = installed_parsers,
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        -- highlighting
        pcall(vim.treesitter.start, ev.buf, lang)

        -- folds
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'

        -- indent
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
    -- Start every file with folds open
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
