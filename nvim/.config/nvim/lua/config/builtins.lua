-- ui2 is experimental in 0.12; message kinds are listed in :h ui-messages.
require("vim._core.ui2").enable({
  msg = {
    target = "msg",
    targets = {
      -- Typed commands win over kind, so their output stays in the cmdline.
      typed_cmd = "cmd",
      search_count = "cmd",
      completion = "cmd",
      wildlist = "cmd",
      confirm = "cmd",
      emsg = "msg",
      echoerr = "pager",
      lua_error = "pager",
      rpc_error = "pager",
      verbose = "pager",
      shell_cmd = "pager",
      shell_out = "pager",
      shell_err = "pager",
      shell_ret = "pager",
      progress = "pager",
    },
    msg = { height = 0.3, timeout = 5000 },
    pager = { height = 0.5 },
  },
})

-- Underline and no updates while typing are already the defaults.
local severity = vim.diagnostic.severity
local icons = require("util.icons").diagnostics
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { prefix = "●", source = "if_many" },
  signs = {
    text = {
      [severity.ERROR] = icons.error,
      [severity.WARN] = icons.warn,
      [severity.INFO] = icons.info,
      [severity.HINT] = icons.hint,
    },
  },
})
