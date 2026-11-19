return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
      },
      diagnostics = {
        globals = { "Snacks", "MiniIcons" },
        disable = { "missing-fields" },
      },
      completion = { callSnippet = "Replace" },
      hint = { enable = true },
      format = { enable = false },
    },
  },
}
