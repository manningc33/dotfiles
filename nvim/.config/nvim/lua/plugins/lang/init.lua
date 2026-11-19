require("plugins.lang.lsp")
require("plugins.lang.treesitter")

require("mason").setup()

require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(buf)
    if not (vim.g.disable_autoformat or vim.b[buf].disable_autoformat) then
      return { timeout_ms = 1000 }
    end
  end,
})

local lang = require("util.lang")

-- Lua
lang.use({
  parsers = { "lua", "luadoc", "luap" },
  formatters = { lua = { "stylua" } },
  servers = { "lua_ls" },
})

-- C / C++
lang.use({
  parsers = { "c", "cpp", "doxygen" },
  formatters = { c = { "clang-format" }, cpp = { "clang-format" } },
  servers = { "clangd" },
})

-- CMake
lang.use({
  parsers = { "cmake" },
  formatters = { cmake = { "cmake_format" } },
  servers = { "neocmake" },
})

-- Go
lang.use({
  parsers = { "go", "gomod", "gosum", "gowork" },
  formatters = { go = { "goimports", "gofumpt" } },
  servers = { "gopls" },
})

require("plugins.lang.markdown")

-- Last, after every language. Deferred past startup since it reads Mason's registry.
vim.schedule(function()
  require("mason-registry").refresh(function()
    require("mason-tool-installer").setup({ ensure_installed = lang.packages(), run_on_start = false })
    require("mason-tool-installer").check_install()
  end)
end)
