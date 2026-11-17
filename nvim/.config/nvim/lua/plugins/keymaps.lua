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
