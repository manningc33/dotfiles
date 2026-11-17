require("oil").setup({
  columns = { "icon", "permissions", "size", "mtime" },
  view_options = { show_hidden = true },
  lsp_file_methods = { autosave_changes = true },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  float = { max_width = 200 },
  keymaps = {
    h = { "actions.toggle_hidden", mode = "n" },
    K = "actions.preview",
    q = { "actions.close", mode = "n" },
    ["<Esc><Esc>"] = { "actions.close", mode = "n" },
    gd = {
      desc = "Toggle detail columns",
      callback = function()
        local detail = #require("oil.config").columns == 1
        require("oil").set_columns(detail and { "icon", "permissions", "size", "mtime" } or { "icon" })
      end,
    },
  },
})
