local opts_map = {
  add = 'gsa', -- Add surrounding in Normal and Visual modes
  delete = 'gsd', -- Delete surrounding
  find = 'gsf', -- Find surrounding (to the right)
  find_left = 'gsF', -- Find surrounding (to the left)
  highlight = 'gsh', -- Highlight surrounding
  replace = 'gsr', -- Replace surrounding
  update_n_lines = 'gsn', -- Update `n_lines`
}
return {
  'nvim-mini/mini.surround',
  keys = function(_, keys)
    -- Populate the keys based on the user's options
    local mappings = {
      { opts_map.add, desc = 'Add Surrounding', mode = { 'n', 'x' } },
      { opts_map.delete, desc = 'Delete Surrounding' },
      { opts_map.find, desc = 'Find Right Surrounding' },
      { opts_map.find_left, desc = 'Find Left Surrounding' },
      { opts_map.highlight, desc = 'Highlight Surrounding' },
      { opts_map.replace, desc = 'Replace Surrounding' },
      { opts_map.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
    }
    mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    mappings = opts_map,
  },
}
