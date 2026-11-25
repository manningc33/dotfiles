local M = {}

-- [+] + icon + relative path + filename, then the navic breadcrumb in the focused window.
function M.render(props)
  local path = vim.api.nvim_buf_get_name(props.buf)
  local oil_dir = require("util.oil").label(props.buf, 20, 17)
  local res = {}

  if vim.bo[props.buf].modified then
    table.insert(res, "[+] ")
  end
  if oil_dir then
    local icon, icon_hl = MiniIcons.get("directory", oil_dir)
    table.insert(res, { icon .. " ", group = icon_hl })
    table.insert(res, { oil_dir, gui = "bold" })
  elseif path == "" then
    table.insert(res, { "[no name]", gui = "bold" })
  else
    local icon, icon_hl = MiniIcons.get("file", path)
    table.insert(res, { icon .. " ", group = icon_hl })
    local name = vim.fn.fnamemodify(path, ":t")
    if not vim.g.incline_path_disabled then
      -- Relative to cwd (or ~). Shortened (lua/plugins/nav -> l/p/nav) only when the
      -- tag would overflow the window; the breadcrumb isn't counted so it doesn't flicker.
      local dir = vim.fn.fnamemodify(vim.fn.fnamemodify(path, ":~:."), ":h")
      if dir ~= "." then
        local used = (vim.bo[props.buf].modified and 4 or 0) + 2 + vim.fn.strdisplaywidth(name)
        local room = vim.api.nvim_win_get_width(props.win) - 4 -- margins + padding
        if used + vim.fn.strdisplaywidth(dir) + 1 > room then
          dir = vim.fn.pathshorten(dir)
        end
        table.insert(res, { dir .. "/", group = "Comment" })
      end
    end
    table.insert(res, { name, gui = "bold" })
  end

  -- Only the focused window: navic tracks the cursor, so other windows' crumbs would be stale.
  if props.focused and not vim.g.navic_disabled then
    local data = require("nvim-navic").get_data(props.buf) or {}
    for _, item in ipairs(vim.list_slice(data, #data - 4)) do
      table.insert(res, { " > ", group = "NavicSeparator" })
      table.insert(res, { item.icon, group = "NavicIcons" .. item.type })
      table.insert(res, { item.name, group = "NavicText" })
    end
  end
  return res
end

return M
