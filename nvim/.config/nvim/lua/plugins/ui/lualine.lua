local lualine_utils = require("util.lualine")

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    refresh = {
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
        -- Macro
        "RecordingEnter",
        "RecordingLeave",
      },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      lualine_utils.root_dir(),
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { lualine_utils.pretty_path() },
    },
    lualine_x = {
      lualine_utils.macro_recording(),
      { "diagnostics", symbols = require("util.icons").diagnostics },
      "diff",
      { "filetype", icons_enabled = false },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
