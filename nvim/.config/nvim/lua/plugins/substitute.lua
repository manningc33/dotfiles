return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    vim.keymap.set("n", "s", substitute.operator, { desc = "Substitute line" })
    vim.keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
    vim.keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
    vim.keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })

    vim.keymap.set("n", "(", require('substitute.exchange').operator, { noremap = true, desc = "exchange" })
    vim.keymap.set("n", "((", require('substitute.exchange').line, { noremap = true, desc = "exchange line" })
    vim.keymap.set("x", "(", require('substitute.exchange').visual, { noremap = true, desc = "exchange in visual mode" })
    vim.keymap.set("n", "(c", require('substitute.exchange').cancel, { noremap = true, desc = "cancel exchange" })
  end,
}
