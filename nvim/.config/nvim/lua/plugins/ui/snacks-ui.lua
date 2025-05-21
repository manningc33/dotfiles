return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
    input = { enabled = true },
    dashboard = {
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', gap = 1, indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
        { section = 'startup' },
      },
    },
  },
}
