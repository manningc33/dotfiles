local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- open and edit mappings
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
  -- vim.keymap.set('n', '<C-t>',  api.node.open.tab,                   opts('Open: New Tab'))

  -- navigation mappings
  vim.keymap.set('n', '>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))

  -- view mappings
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
  vim.keymap.set('n', 'h', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
  vim.keymap.set('n', 'gh', api.tree.toggle_gitignore_filter, opts('Toggle Filter: Dotfiles'))
  vim.keymap.set('n', 'r', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'f', api.live_filter.start, opts('Live Filter: Start'))
  vim.keymap.set('n', 'F', api.live_filter.clear, opts('Live Filter: Clear'))
  vim.keymap.set('n', '*', api.marks.toggle, opts('Toggle Bookmark'))
  vim.keymap.set('n', 'x', api.tree.toggle_no_bookmark_filter, opts('Toggle Filter: No Bookmark'))

  -- file operations mappings
  vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'm', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'M', api.fs.rename_full, opts('Rename: Full Path'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
  vim.keymap.set('n', 'bm', api.marks.bulk.move, opts('Move Bookmarked'))

  -- info mappings
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', 'i', api.node.show_info_popup, opts('Info'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup({
      on_attach = on_attach,
      disable_netrw = true,
      view = {
        preserve_window_proportions = true,
      },
      renderer = {
        group_empty = true,
        indent_width = 1,
        highlight_opened_files = 'all',
        icons = {
          git_placement = 'after',
        },
        indent_markers = {
          enable = true,
        },
      },
      update_focused_file = {
        enable = true,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
    -- toggle tree keymap, finds file
    vim.keymap.set('n', '+', ':NvimTreeFindFileToggle<CR>', { desc = 'toggle nvim-tree' })
    vim.keymap.set('n', '<C-Home>', ':NvimTreeFocus<CR>', { desc = 'focus nvim-tree' })

    -- autoclose if last buffer
    vim.api.nvim_create_autocmd('QuitPre', {
      callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match('NvimTree_') ~= nil then
            table.insert(invalid_win, w)
          end
        end
        if #invalid_win == #wins - 1 then
          -- Should quit, so we close all invalid windows.
          for _, w in ipairs(invalid_win) do
            vim.api.nvim_win_close(w, true)
          end
        end
      end,
    })
  end,
}
