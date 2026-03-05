local detail = false
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  opts = {
    default_file_explorer = true,
    use_default_keymaps = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    float = {
      max_width = 0.7,
      max_height = 0.7,
    },
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = 'actions.select_split',
      ['<C-t>'] = 'actions.select_tab',
      ['K'] = 'actions.preview',
      ['<Esc><Esc>'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['h'] = 'actions.toggle_hidden',
      ['g.'] = 'actions.toggle_trash',
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
          else
            require('oil').set_columns({ 'icon' })
          end
        end,
      },
    },
  },
  keys = {
    {
      '-',
      function() require('oil').open_float() end,
      desc = 'Open up oil in floating window',
    },
    { '<leader><leader>-', function() require('oil').open() end, desc = 'Open up oil in current window' },
  },
}
