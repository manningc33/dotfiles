if vim.loader then
  vim.loader.enable()
end
require("util.usage").setup()

require("config.options")
require("config.builtins")
require("config.keymaps")
require("config.autocmds")
require("plugins")
