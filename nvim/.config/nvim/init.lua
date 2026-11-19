if vim.loader then
  vim.loader.enable()
end

require("config.options")
require("config.builtins")
require("config.keymaps")
require("config.autocmds")
require("plugins")
