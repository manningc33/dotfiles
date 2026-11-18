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
  tools = { "lua-language-server", "stylua" },
  formatters = { lua = { "stylua" } },
  servers = { "lua_ls" },
})

-- C / C++
lang.use({
  parsers = { "c", "cpp", "doxygen" },
  tools = { "clangd", "clang-format" },
  formatters = { c = { "clang-format" }, cpp = { "clang-format" } },
  servers = { "clangd" },
})

-- Last, once every language has added its tools.
require("mason-tool-installer").setup({ ensure_installed = lang.tools() })
