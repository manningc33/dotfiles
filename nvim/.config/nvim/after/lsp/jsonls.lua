return {
  settings = { json = { validate = { enable = true } } },
  -- SchemaStore's catalog is only loaded once the server starts.
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
}
