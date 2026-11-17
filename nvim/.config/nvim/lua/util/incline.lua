local M = {}

-- [+] + icon + filename, then the navic breadcrumb in the focused window.
function M.render(props)
  local path = vim.api.nvim_buf_get_name(props.buf)
  local res = {}

  if vim.bo[props.buf].modified then
    table.insert(res, "[+] ")
  end
  if path == "" then
    table.insert(res, { "[no name]", gui = "bold" })
  else
    local icon, icon_hl = MiniIcons.get("file", path)
    table.insert(res, { icon .. " ", group = icon_hl })
    table.insert(res, { vim.fn.fnamemodify(path, ":t"), gui = "bold" })
  end

  -- Only the focused window: navic tracks the cursor, so other windows' crumbs would be stale.
  if props.focused then
    for _, item in ipairs(require("nvim-navic").get_data(props.buf) or {}) do
      table.insert(res, { " > ", group = "NavicSeparator" })
      table.insert(res, { item.icon, group = "NavicIcons" .. item.type })
      table.insert(res, { item.name, group = "NavicText" })
    end
  end
  return res
end

return M
