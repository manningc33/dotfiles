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
