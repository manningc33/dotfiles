return {
  -- yamlls's own schema download is off so it doesn't clash with SchemaStore's; the empty url avoids an error.
  settings = { yaml = { schemaStore = { enable = false, url = "" } } },
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
}
