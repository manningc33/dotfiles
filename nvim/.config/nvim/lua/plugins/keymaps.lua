local map = function(keymaps)
  for _, k in ipairs(keymaps) do
    local opts = { silent = true }
    for key, value in pairs(k) do
      if type(key) == "string" and key ~= "mode" then
        opts[key] = value
      end
    end
    vim.keymap.set(k.mode or "n", k[1], k[2], opts)
  end
end

-- Snacks
map({
  -- Picker
  { "\\", Snacks.picker.files, desc = "Find files" },
  { "<leader>fg", Snacks.picker.grep, desc = "Live grep" },
  { "<leader>ff", Snacks.picker.resume, desc = "Resume last picker" },
  { "<leader>fb", Snacks.picker.buffers, desc = "Buffers" },
  { "<leader>fd", Snacks.picker.diagnostics, desc = "Diagnostics" },
  { "<leader>fn", Snacks.picker.notifications, desc = "Notification history" },
  { "<leader>fh", Snacks.picker.git_diff, desc = "Git hunks" },
  { "<leader>fk", Snacks.picker.keymaps, desc = "Keymaps" },

  -- Words: wrapped to pass the count.
  {
    "]]",
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = "Next reference",
  },
  {
    "[[",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = "Prev reference",
  },
})

-- Toggles
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal level" }):map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle({
  name = "Navic breadcrumb",
  get = function()
    return not vim.g.navic_disabled
  end,
  set = function(state)
    vim.g.navic_disabled = not state
    require("incline").refresh()
  end,
}):map("<leader>un")
Snacks.toggle.zoom():map("<leader>uz"):map("<leader>wm")
Snacks.toggle({
  name = "Format on save",
  get = function()
    return not vim.g.disable_autoformat
  end,
  set = function(state)
    vim.g.disable_autoformat = not state
  end,
}):map("<leader>uf")
Snacks.toggle({
  name = "Format on save (buffer)",
  get = function()
    return not vim.b.disable_autoformat
  end,
  set = function(state)
    vim.b.disable_autoformat = not state
  end,
}):map("<leader>uF")

-- Oil
map({
  {
    "-",
    function()
      require("oil").open_float(nil, { preview = {} })
    end,
    desc = "Oil (float)",
  },
  { "<leader><leader>-", require("oil").open, desc = "Oil (current window)" },
})

-- Flash
map({
  { "s", require("flash").jump, mode = { "n", "x", "o" }, desc = "Flash" },
  { "S", require("flash").treesitter, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
  { "r", require("flash").remote, mode = "o", desc = "Remote flash" },
  { "R", require("flash").treesitter_search, mode = { "o", "x" }, desc = "Treesitter search" },
  { "<C-s>", require("flash").toggle, mode = "c", desc = "Toggle flash search" },
})

-- Windows nav and resize (w/ Tmux)
map({
  { "<C-Left>", require("smart-splits").move_cursor_left, mode = { "n", "v" }, desc = "Split/pane left" },
  { "<C-Right>", require("smart-splits").move_cursor_right, mode = { "n", "v" }, desc = "Split/pane right" },
  { "<C-Down>", require("smart-splits").move_cursor_down, mode = { "n", "v" }, desc = "Split/pane down" },
  { "<C-Up>", require("smart-splits").move_cursor_up, mode = { "n", "v" }, desc = "Split/pane up" },
  { "<S-Left>", require("smart-splits").resize_left, mode = { "n", "i", "v" }, desc = "Resize left" },
  { "<S-Right>", require("smart-splits").resize_right, mode = { "n", "i", "v" }, desc = "Resize right" },
  { "<S-Down>", require("smart-splits").resize_down, mode = { "n", "i", "v" }, desc = "Resize down" },
  { "<S-Up>", require("smart-splits").resize_up, mode = { "n", "i", "v" }, desc = "Resize up" },
})

-- LSP
-- Neovim's gr* defaults would make `gr` wait for a second key.
for _, lhs in ipairs({ "gra", "gri", "grn", "grr", "grt", "grx" }) do
  pcall(vim.keymap.del, { "n", "x" }, lhs)
end
map({
  { "gd", Snacks.picker.lsp_definitions, desc = "Definition" },
  { "gD", Snacks.picker.lsp_declarations, desc = "Declaration" },
  { "gy", Snacks.picker.lsp_type_definitions, desc = "Type definition" },
  { "gr", Snacks.picker.lsp_references, desc = "References" },
  { "gI", Snacks.picker.lsp_implementations, desc = "Implementations" },
  { "gai", Snacks.picker.lsp_incoming_calls, desc = "Incoming calls" },
  { "gao", Snacks.picker.lsp_outgoing_calls, desc = "Outgoing calls" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature help" },
  { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help" },
  { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "x" }, desc = "Code actions" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename symbol" },
  { "<leader>cR", Snacks.rename.rename_file, desc = "Rename file" },
  { "<leader>cs", Snacks.picker.lsp_symbols, desc = "Document symbols" },
  { "<leader>cS", Snacks.picker.lsp_workspace_symbols, desc = "Workspace symbols" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostics" },
  { "<leader>cf", require("conform").format, desc = "Format" },
  { "<leader>cL", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP info" },
})
