return {
  cmd = { "clangd", "--completion-style=detailed" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    "meson.build",
    "build.ninja",
    ".git",
  },
  keys = {
    { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch source/header" },
  },
}
