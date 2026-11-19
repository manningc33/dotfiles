local M = {}

local tools, servers, formatters = {}, {}, {}

-- Sets up one language's parsers, formatters, and servers. `tools` lists extra Mason packages that aren't
-- already a server or formatter.
function M.use(spec)
  if spec.parsers then
    require("nvim-treesitter").install(spec.parsers)
  end
  vim.list_extend(tools, spec.tools or {})
  for ft, names in pairs(spec.formatters or {}) do
    require("conform").formatters_by_ft[ft] = names
    vim.list_extend(formatters, names)
  end
  if spec.servers then
    vim.lsp.enable(spec.servers)
    vim.list_extend(servers, spec.servers)
  end
end

-- Every language's Mason packages, for mason-tool-installer once all languages are in. Servers and formatters
-- are matched through Mason's registry, which records each package's lspconfig name and the commands it
-- installs. Anything Mason doesn't have (conform built-ins, system-installed tools) is skipped.
function M.packages()
  local by_server, by_command = {}, {}
  for _, spec in ipairs(require("mason-registry").get_all_package_specs()) do
    local server = vim.tbl_get(spec, "neovim", "lspconfig")
    if server then
      by_server[server] = spec.name
    end
    for command in pairs(spec.bin or {}) do
      by_command[command] = spec.name
    end
  end

  local packages = vim.deepcopy(tools)
  for _, server in ipairs(servers) do
    table.insert(packages, by_server[server])
  end
  for _, name in ipairs(formatters) do
    local command = (require("conform").get_formatter_config(name) or {}).command
    table.insert(packages, type(command) == "string" and by_command[command] or nil)
  end
  return vim.list.unique(packages)
end

return M
