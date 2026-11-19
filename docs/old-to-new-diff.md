## others

- On `VimResized`, equalizes splits in every tab (`tabdo wincmd =`) and returns to the current tab.
- **Close with `q`**: these filetypes get a buffer-local `q` → `:close` and are made unlisted: `PlenaryTestPopup`, `grug-far`, `help`, `lspinfo`, `notify`, `qf`, `spectre_panel`, `startuptime`, `tsplayground`, `neotest-output`, `checkhealth`, `neotest-summary`, `neotest-output-panel`, `dbout`, `gitsigns.blame`, `oil`.
- `<leader>x`: `chmod +x` the current file
-`zff`: Folds the current block
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) on `LazyFile`, `mode = 'topline'`: the enclosing function/class sticks to the top of the window. `<leader>ut` toggles it.
- snacks: `dashboard`, `zen`
- `+`: file tree, toggle tree reveal current file
- `harpoon`: `<leader>H` add file,  `<leader>h`: toggle quick menu, `<leader>1` … `<leader>5`: Jumps to file 1–5
- `<leader>sr`: opens a transient grug-far, prefilled with a `*.<ext>` files filter for the current file's extension
- `]H` / `[H`: Last / first hunk
- `<leader>ghd` / `<leader>ghD`: Diffs against the index / against `HEAD~`
- `ih` (o, x): Selects the hunk as a text object
- [neogen](https://github.com/danymat/neogen) with defaults. `<leader>cn` generates a doc comment for the thing under the cursor.
- [mini.surround](https://github.com/nvim-mini/mini.surround), lazy-loaded on its keys, all under `gs`:
- [substitute.nvim](https://github.com/gbprod/substitute.nvim) for substitute and exchange
- [persistence.nvim](https://github.com/folke/persistence.nvim) on `BufReadPre`, defaults. Saves a session per directory on exit once a file has been opened.
- more snacks pickers
- docker config:
  - Parser `dockerfile`. Servers **dockerls** and **docker_compose_language_service**.
  - Mason tools: hadolint, gofumpt, golangci-lint.
  - Lints Dockerfiles with **golangcilint**.

## other snacks pickers

| Keys                      | Action                              |
| ------------------------- | ------------------------------------|
| `<leader>fR`              | Recent files in cwd                 |
| `<leader>fp`              | Projects                            |
| `<leader>/` / `<leader>sg`| Live-greps                          |
| `<leader>sG`              | `git grep`                          |
| `<leader>sw` (n, x)       | Greps the word or selection         |
| `<leader>sb`              | Lines in the buffer                 |
| `<leader>sB`              | Greps open buffers                  |
| `<leader>:` / `<leader>sc`| Command history                     |
| `<leader>sC`              | Commands                            |
| `<leader>s/`              | Search history                      |
| `<leader>s"`              | Registers                           |
| `<leader>sa`              | Autocmds                            |
| `<leader>sd` / `<leader>sD` | Diagnostics, workspace / buffer   |
| `<leader>sh` / `<leader>sH` | Help pages / highlight groups     |
| `<leader>sj`              | Jump list                           |
| `<leader>sl` / `<leader>sq` | Location list / quickfix          |
| `<leader>sm` / `<leader>sM` | Marks / man pages                 |
| `<leader>sp`              | Searches plugin specs               |
| `<leader>gS`              | Git stash                           |
