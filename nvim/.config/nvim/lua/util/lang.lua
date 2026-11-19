local M = {}

local tools = {}

-- Sets up one language's parsers, Mason tools, formatters, and servers.
function M.use(spec)
  if spec.parsers then
    require("nvim-treesitter").install(spec.parsers)
  end
  vim.list_extend(tools, spec.tools or {})
  for ft, formatters in pairs(spec.formatters or {}) do
    require("conform").formatters_by_ft[ft] = formatters
  end
  if spec.servers then
    vim.lsp.enable(spec.servers)
  end
end

-- Every language's Mason tools, for mason-tool-installer once all languages are in.
function M.tools()
  return tools
end

return M
