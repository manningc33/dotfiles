-- Code never gets spell or emoji.
local per_filetype = {}
for _, ft in ipairs(require("util").editor.prose_filetypes) do
  per_filetype[ft] = { inherit_defaults = true, "spell", "emoji" }
end

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<M-Right>"] = { "snippet_forward", "fallback" },
    ["<M-Left>"] = { "snippet_backward", "fallback" },
    ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
    ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
    ["<Up>"] = { "fallback" },
    ["<Down>"] = { "fallback" },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = {
      draw = {
        treesitter = { "lsp" },
        components = {
          kind_icon = {
            text = function(ctx)
              return (MiniIcons.get("lsp", ctx.kind))
            end,
            highlight = function(ctx)
              return select(2, MiniIcons.get("lsp", ctx.kind))
            end,
          },
        },
      },
    },
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = function()
          return vim.fn.getcmdtype() == ":"
        end,
      },
      list = { selection = { preselect = false } },
    },
  },
  sources = {
    per_filetype = per_filetype,
    providers = {
      spell = { name = "Spell", module = "blink-cmp-spell" },
      emoji = { name = "Emoji", module = "blink-emoji", score_offset = 50 },
    },
  },
})
