## 0. Prerequisites

### 0.1 Neovim

- [Neovim](https://neovim.io/doc/install/) **0.11** or newer.
  - The config relies on built-ins that landed in 0.11: `vim.lsp.config`, which _mason-lspconfig_ v2 enables servers through.

### 0.2 CLI tools

| Tool                           | Why                                                      |
| ------------------------------ | -------------------------------------------------------- |
| `git`                          | _lazy.nvim_ bootstraps itself and clones plugins with it |
| `tree-sitter` CLI + C compiler | _nvim-treesitter_'s main branch builds parsers locally   |
| `curl` and `tar`               | Parser and _blink.cmp_ binary downloads                  |
| Node.js + npm                  | _Mason_ installs several language servers through npm    |
| Go and Python 3                | _Mason_ installs the Go and CMake/C++ tools through them |
| `ripgrep` and `fd`             | Back the text search and the file finder                 |
| `lazygit` and `git-delta`      | The git UI and its diff renderer                         |

### 0.3 Font

- A Nerd Font. I use **CaskaydiaCove Nerd Font**.
  - Icons appear in the bufferline, statusline, completion menu, and file explorers, so a plain font shows boxes.

### 0.4 Git

- The config folder is a git repository.
- `lazy-lock.json` is committed. `.gitignore` lists `.luarc.json`.

## 1. Foundation

### 1.0 Start a session

- `nvim` with no file opens the _snacks.nvim_ dashboard (2.6).
- Sessions aren't restored automatically (11.1).

### 1.1 Layout

- `~/.config/nvim`: the config root folder
  - `init.lua`, in order:
        1. requires `core.options`, `core.keymaps`, `core.autocmds`
        2. bootstraps _lazy.nvim_ (1.10)
        3. registers a custom `LazyFile` event = `BufReadPost`, `BufNewFile`, `BufWritePre`
        4. calls `require('lazy').setup` importing `plugins`, `plugins.ui`, `plugins.utility`, `plugins.coding`, `plugins.editor`, `plugins.lang`, in that order
  - `lua/core/`: plain Neovim settings
    - `options.lua`, `keymaps.lua`, `autocmds.lua`
  - `lua/plugins/`: one _lazy.nvim_ spec file per plugin (or small family), each `return { ... }`
    - top level: `colortheme`, `formatting`, `gitsigns`, `lazygit`, `lint`, `lsp`, `misc`, `tmux`, `treesitter`, `which-key`
    - `ui/`: `bufferline`, `lualine`, `snacks-ui`, `treesitter-context`
    - `utility/`: `persistence`, `snacks-toggle`
    - `coding/`: `autopairs`, `blink`, `comment`, `dial`, `mini-ai`, `mini-move`, `mini-surround`, `neogen`, `substitute`, `ts-comments`
    - `editor/`: `flash`, `grug`, `harpoon`, `nvim-tree`, `oil`, `snacks-explorer` (fully commented out, returns `{}`), `snacks-picker`
    - `lang/`: `c_cpp`, `cmake`, `docker`, `go`, `json_toml_yaml`, `lua`, `markdown`, `typst`
  - Plugin keymaps live **inside each plugin's spec** (`keys = {...}` or in `config`), not in a central file.
  - Language files only _extend_ other plugins' specs (Treesitter parsers, Mason packages, lspconfig servers, conform formatters, nvim-lint linters). They rely on `opts_extend = { 'ensure_installed' }` so lists are appended, not replaced.
- `.stylua.toml`: **2 spaces**, `column_width` **120**, Unix line endings, `AutoPreferSingle` quotes, `call_parentheses = "Always"`, `collapse_simple_statement = "FunctionOnly"`.
- `.luarc.json` declares `Snacks` as a known global.

### 1.2 Leader and basics

- Leader and local leader are **Space**.
- Mouse is **on** (`mouse = 'a'`).
- Clipboard is `unnamedplus`, so yank and paste go through the system clipboard.
- Indent is **4 spaces**:
  - `tabstop`, `shiftwidth`, and `softtabstop` are all **4**
  - `expandtab`, `autoindent` and `smartindent` are **on**
  - _vim-sleuth_ (9.8) overrides these per file when it can detect the file's own style.
- `-` counts as part of a word, so `foo-bar` is one word.
- `whichwrap` is `bs<>[]hl`: `h`, `l`, arrows and backspace wrap onto the previous/next line.
- `vim.g.autoformat = true`: format-on-save is on globally (5.6).

### 1.3 Look of the buffer

- **Hybrid** line numbers: `number` + `relativenumber` **on**, `numberwidth` **4**.
- `cursorline` **on** in every window. No wrap, `scrolloff` **8**, `sidescrolloff` **8**, `breakindent` **on**.
- `signcolumn` **always on** (`yes`).
- `cmdheight` **1**, `showmode` **off** (lualine shows the mode). `laststatus` is left at its default, so each window has its own statusline.
- `showtabline` **2**, but bufferline hides the tabline while only one buffer is open (2.3).
- Popup menu: at most **10** rows (`pumheight` **10**).
- `conceallevel` **0**, so markup like backticks stays visible. `<leader>uc` toggles it.
- `termguicolors` **on**, `fileencoding` `utf-8`.

### 1.4 Search, files, undo

- `ignorecase` + `smartcase` **on**. `hlsearch` **on**, cleared with `Esc`.
- `completeopt` is `menuone,noselect`. `shortmess` adds `c`.
- `swapfile`, `backup` and `writebackup` **off**.
- Persistent undo (`undofile` **on**).
- `updatetime` **250**.
- `formatoptions` has `c`, `r`, `o` removed, so comments aren't continued on Enter/`o`.

### 1.5 Splits and folds

- New splits open **below** and to the **right**.
- Folds come from **Treesitter** (`foldmethod=expr`, `foldexpr=v:lua.vim.treesitter.foldexpr()`), set per window in the Treesitter FileType autocmd (4.1).
- `foldlevel` and `foldlevelstart` are **99**, so everything starts unfolded.
- `zff` creates a manual fold over the current block (`V%zf`).

### 1.6 Messages

Not used.

### 1.7 Autocmds

All in `core/autocmds.lua`, each in its own cleared augroup.

- **Last position**: reopening a file puts the cursor back where it was (the `"` mark), except in `gitcommit`.
- **checktime**: on `FocusGained`, `TermClose`, `TermLeave`, reloads files changed outside Neovim (skipped for `nofile` buffers).
- Yanked text flashes briefly (`vim.highlight.on_yank`).
- **Resize**: on `VimResized`, equalizes splits in every tab (`tabdo wincmd =`) and returns to the current tab.
- **Wrap + spell**: `text`, `plaintex`, `typst`, `gitcommit`, `markdown` buffers get `wrap` and `spell` on.
- **Close with `q`**: these filetypes get a buffer-local `q` → `:close` and are made unlisted: `PlenaryTestPopup`, `grug-far`, `help`, `lspinfo`, `notify`, `qf`, `spectre_panel`, `startuptime`, `tsplayground`, `neotest-output`, `checkhealth`, `neotest-summary`, `neotest-output-panel`, `dbout`, `gitsigns.blame`, `oil`.

### 1.8 Core keymaps

All set with `noremap` + `silent` by default, through a small `set_keymap` helper.

| Keys                                    | Action                                                                                     | Notes                                                                 |
| --------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| `x`                                     | Deletes a character without copying                                                        |                                                                       |
| `g)` (n, x) / `g))`                     | Delete operator / delete line without copying                                              | Black-hole register versions of `d` / `dd`.                           |
| `dd`                                    | Deletes the line; on a blank line, doesn't copy it                                         | Deleting empty lines never clobbers the register.                     |
| `<Down>` / `<Up>` (n, x)                | `gj` / `gk` when there's no count                                                          | Moves by screen line on wrapped text.                                 |
| `<Down>` / `<Up>` (insert)              | `<C-o>g<Down>` / `<C-o>g<Up>`                                                              |                                                                       |
| `<Home>` (n, v, i)                      | Goes to the first non-blank; pressed again, to column 0                                    | Smart home. Operator-pending `<Home>` is `^`.                         |
| `<End>` (n, v, i)                       | `g$`                                                                                       |                                                                       |
| `Esc` (n, i)                            | Clears search highlight, then escapes                                                      |                                                                       |
| `<S-Tab>` (insert)                      | Dedents (`<C-d>`)                                                                          | In normal mode `<S-Tab>` cycles buffers (2.3).                        |
| `J`                                     | Joins lines, cursor stays put (`mzJ\`z`)                                                   |                                                                       |
| `<C-d>` / `<C-u>`                       | Half-page scroll, then center                                                              |                                                                       |
| `PageDown` / `PageUp`                   | Same as `<C-d>` / `<C-u>`, centered, folds opened                                          |                                                                       |
| `n` / `N`                               | Next/prev match, centered, folds opened                                                    |                                                                       |
| `<` / `>` (visual)                      | Indent and keep the selection                                                              |                                                                       |
| `<leader>-` / `<leader>\|`              | Split below / right                                                                        |                                                                       |
| `<leader>wd`                            | Closes the window                                                                          | `<leader>w` is also a which-key proxy for `<C-w>` (2.8).              |
| `<leader>to` `<leader>tx`               | New tab / close tab                                                                        |                                                                       |
| `<leader>tn` `<leader>tp`               | Next / previous tab                                                                        | Tab cycling is not on `Tab`; that's buffers.                          |
| `<leader>W`                             | Saves without autocmds (`:noautocmd w`)                                                    | Skips format-on-save.                                                 |
| `<leader>*`                             | Starts `:%s/\<word\>/word/gI` for the word under the cursor, cursor on the replacement     |                                                                       |
| `<leader>x`                             | `chmod +x` the current file                                                                |                                                                       |
| `[d` / `]d`                             | Previous / next diagnostic                                                                 |                                                                       |
| `<leader>dd`                            | Diagnostic float                                                                           |                                                                       |
| `<leader>q`                             | Diagnostics to the location list                                                           | |
| `<leader>L`                             | Opens `:Lazy`                                                                              |                                                                       |
| `<leader>lg`                            | Opens lazygit (6.4)                                                                        |                                                                       |
| `zff`                                   | Folds the current block                                                                    |                                                                       |

### 1.9 Close hidden buffers

Not used.

### 1.10 Plugin manager

[lazy.nvim](https://github.com/folke/lazy.nvim), bootstrapped from `init.lua`.

- `change_detection.notify = false`: config edits reload silently.
- Specs for the same plugin are spread over several files and merged by _lazy.nvim_ (e.g. _snacks.nvim_, _conform_, _nvim-lspconfig_, _mason-lspconfig_, _mason-tool-installer_, _nvim-treesitter_, _nvim-lint_).
- Most plugins lazy-load on `LazyFile`, `VeryLazy`, `InsertEnter`, a command, or their keys. Eager (`lazy = false`): _catppuccin_, _snacks.nvim_, _nvim-treesitter_, _oil_. _vim-tmux-navigator_ and _better-vim-tmux-resizer_ have no trigger, so they load at startup too.

## 2. Look & feel

### 2.1 Colorscheme

- [catppuccin](https://github.com/catppuccin/nvim), default flavour (mocha), **transparent** background, _blink.cmp_ integration on.
  - Loaded first (`priority = 1000`, `lazy = false`), applied with `vim.cmd.colorscheme('catppuccin')`.

### 2.2 Icons

- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons), pulled in as a dependency of _oil_ with default `opts = {}`.

### 2.3 Tabline

[bufferline.nvim](https://github.com/akinsho/bufferline.nvim) shows **buffers**, not tabs. Loads on `VeryLazy`.

- Hidden while only one buffer is open (`always_show_bufferline = false`).
- Shows LSP diagnostic counts per buffer (`diagnostics = 'nvim_lsp'`).
- Close button and right-click close through `Snacks.bufdelete`, which keeps the window layout.
- Offset: when _nvim-tree_ is open, the bar starts after it with a left-aligned "File Tree" title in the `Directory` highlight.

| Keys                  | Action                         |
| --------------------- | ------------------------------ |
| `<Tab>` / `<S-Tab>`   | Next / previous buffer         |
| `]b` / `[b`           | Move the buffer right / left   |
| `<leader>bd`          | Deletes the buffer (Snacks)    |
| `<leader>bD`          | `:bd`                          |
| `<leader>bp`          | Toggles pin                    |
| `<leader>bP`          | Closes all non-pinned buffers  |
| `<leader>br` / `bl`   | Close buffers right / left     |
| `<leader>bo`          | Closes other buffers           |
| `<leader>bb`          | Picks a buffer by letter       |

### 2.4 Statusline

[lualine](https://github.com/nvim-lualine/lualine.nvim), loads on `VeryLazy`, theme `auto` (follows catppuccin), icons on, one statusline **per window** (no `globalstatus`).

| Section | Content                                                                                               |
| ------- | ----------------------------------------------------------------------------------------------------- |
| a       | Mode                                                                                                  |
| b       | Diagnostics                                                                                           |
| c       | File name, with new-file status                                                                       |
| x       | `exchange in progress` in pink while a _substitute.nvim_ exchange is pending, git diff counts, file format, encoding, filetype |
| y       | Git branch                                                                                            |
| z       | Progress, then line:column                                                                            |

- `ignore_focus = { 'NvimTree' }`: the tree never looks like the active window.
- Extensions: `oil`, `nvim-tree`, `lazy`, `mason`, `man`, `quickfix`.

### 2.5 Window labels

Each window has a **winbar** from lualine instead of a floating label.

- Active window: path relative to cwd, then the [nvim-navic](https://github.com/SmiteshP/nvim-navic) breadcrumb (on the left), and the search count (on the right).
  - navic: auto-attaches to LSP, separator `' '`, highlighted, depth limit **5**, lazy context updates.
  - The breadcrumb shows only when navic is available and `vim.g.navic_disable` isn't set. `<leader>un` toggles it.
- Inactive windows: relative path with new-file status only.

### 2.6 Snacks

[snacks.nvim](https://github.com/folke/snacks.nvim), `lazy = false`, `priority = 1000`. One plugin, spec spread over `ui/snacks-ui.lua`, `editor/snacks-picker.lua`, `lazygit.lua`, `utility/snacks-toggle.lua`.

Enabled modules: **indent**, **input**, **dashboard**, **picker** (3.1), **lazygit** (6.4), **zen**, plus the `toggle`, `bufdelete` and `keymap` helpers.

- **Indent guides**: on, no animation, no scope highlighting.
- **Dashboard**: empty header, then:
    1. Keymaps (default Snacks key list: find file, new file, grep, recent, config, restore session, Lazy, quit), gap 1
    2. Recent files
    3. Projects
    4. Startup time
  - Each list section is indented **2** with a Nerd Font icon in its title.
- **Zen**: dims nothing (`dim = false`) and keeps git signs visible.

### 2.7 UI toggles

Every `<leader>u*` key is a `Snacks.toggle`, which shows its on/off state in which-key. The core ones are registered on the `VeryLazy` event in `utility/snacks-toggle.lua`; plugin ones live in their plugin's spec.

| Keys                      | Toggles                                                |
| ------------------------- | ------------------------------------------------------ |
| `<leader>us`              | Spelling                                               |
| `<leader>uw`              | Wrap                                                   |
| `<leader>uL`              | Relative number                                        |
| `<leader>ul`              | Line numbers                                           |
| `<leader>ud`              | Diagnostics                                            |
| `<leader>uc`              | `conceallevel` (0 ↔ current, or 2)                     |
| `<leader>uT`              | Treesitter highlighting                                |
| `<leader>uh`              | Inlay hints                                            |
| `<leader>ug`              | Indent guides                                          |
| `<leader>uD`              | Dim inactive code                                      |
| `<leader>uz`              | Zen mode                                               |
| `<leader>uZ` / `<leader>wm` | Zoom the window                                      |
| `<leader>uf` / `<leader>uF` | Format on save, global / buffer (5.6)                |
| `<leader>uG`              | Git signs (6.1)                                        |
| `<leader>ut`              | Treesitter context (4.3)                               |
| `<leader>un`              | navic breadcrumb (2.5)                                 |
| `<leader>um`              | Rendered Markdown (10.7)                               |

### 2.8 Which-key

[which-key.nvim](https://github.com/folke/which-key.nvim) on `VeryLazy`, popup after **500 ms**.

- Mapping icons are off (`icons.mappings = vim.g.have_nerd_font`, which is never set).
- Groups: `<leader>c` code (n, x), `<leader>d` document, `<leader>r` rename, `<leader>f` find/files, `<leader>g` git, `<leader>s` search, `<leader>u` ui toggle, `[` prev, `]` next, `gs` surround, `z` fold.
- `<leader>w` windows is a **proxy** for `<C-w>` and lists the open windows. `<leader>b` buffers lists open buffers.
- `<leader>?` shows buffer-local keymaps.

## 3. Navigating

### 3.1 Picker

The _snacks.nvim_ picker with defaults (no hidden files unless toggled in the picker).

| Keys                      | Action                                         | Notes                               |
| ------------------------- | ---------------------------------------------- | ----------------------------------- |
| `\`                       | Smart picker (buffers + recent + files)        | The main file finder.               |
| `<leader>,` / `<leader>fb`| Lists buffers                                  |                                     |
| `<leader>fB`              | All buffers, including hidden and no-file      |                                     |
| `<leader>ff`              | Finds files                                    |                                     |
| `<leader>fg`              | Finds git-tracked files                        |                                     |
| `<leader>f.`              | Recent files                                   |                                     |
| `<leader>fR`              | Recent files in cwd                            |                                     |
| `<leader>fp`              | Projects                                       |                                     |
| `<leader>fr`              | Reopens the last picker                        |                                     |
| `<leader>/` / `<leader>sg`| Live-greps                                     |                                     |
| `<leader>sG`              | `git grep`                                     |                                     |
| `<leader>sw` (n, x)       | Greps the word or selection                    |                                     |
| `<leader>sb`              | Lines in the buffer                            |                                     |
| `<leader>sB`              | Greps open buffers                             |                                     |
| `<leader>:` / `<leader>sc`| Command history                                |                                     |
| `<leader>sC`              | Commands                                       |                                     |
| `<leader>s/`              | Search history                                 |                                     |
| `<leader>s"`              | Registers                                      |                                     |
| `<leader>sa`              | Autocmds                                       |                                     |
| `<leader>sd` / `<leader>sD` | Diagnostics, workspace / buffer              |                                     |
| `<leader>sh` / `<leader>sH` | Help pages / highlight groups                |                                     |
| `<leader>si`              | Icons                                          |                                     |
| `<leader>sj`              | Jump list                                      |                                     |
| `<leader>sk`              | Keymaps                                        |                                     |
| `<leader>sl` / `<leader>sq` | Location list / quickfix                     |                                     |
| `<leader>sm` / `<leader>sM` | Marks / man pages                            |                                     |
| `<leader>sp`              | Searches plugin specs                          |                                     |
| `<leader>su`              | Undo tree                                      |                                     |
| `<leader>gd`              | Git diff hunks                                 |                                     |
| `<leader>gs`              | Git status                                     |                                     |
| `<leader>gS`              | Git stash                                      |                                     |

### 3.2 File explorer

[oil.nvim](https://github.com/stevearc/oil.nvim) replaces netrw (`default_file_explorer = true`, `lazy = false`).

- The directory is a buffer, so renaming, moving, and deleting files is plain text editing followed by `:w`.
- Deletes go to the **trash**. Simple edits skip the confirm prompt. Watches the disk for changes.
- Columns: icon only. `gd` toggles a detail view (icon, permissions, size, modified time).
- Float is at most **70%** wide and tall.
- Default keymaps stay on, with these overrides:

| Keys                      | Action                                    | Notes                             |
| ------------------------- | ----------------------------------------- | --------------------------------- |
| `-`                       | Opens oil as a float                      | Global key.                       |
| `<leader><leader>-`       | Opens oil in the current window           | Global key.                       |
| `<CR>`                    | Opens the entry                           |                                   |
| `<C-s>` / `<C-h>` / `<C-t>` | Opens in vsplit / split / tab           |                                   |
| `K`                       | Preview                                   |                                   |
| `-`                       | Parent directory                          | Inside oil.                       |
| `_` / `` ` `` / `~`       | Open cwd / `:cd` / `:tcd` to the directory |                                  |
| `gs`                      | Change sort                               |                                   |
| `h`                       | Toggles hidden files                      |                                   |
| `g.`                      | Toggles trash view                        |                                   |
| `gd`                      | Toggles detail columns                    |                                   |
| `<C-l>`                   | Refresh                                   |                                   |
| `q` / `<Esc><Esc>`        | Closes oil                                | `q` comes from the autocmd (1.7). |
| `g?`                      | Help                                      |                                   |

### 3.3 File tree

[nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua), a sidebar alongside oil. Loads on its keys or `:NvimTreeFindFileToggle` / `:NvimTreeFocus`.

- Disables netrw. Keeps window proportions when it opens.
- Renderer: empty folders grouped, indent width **1** with indent markers, opened files highlighted (`all`), git icons **after** the name.
- Follows the current file. Shows diagnostics on folders only while they're closed.
- Opening a file **closes** the tree.
- If the tree would be the last window left on `:q`, it closes itself so Neovim quits.
- All default keymaps are replaced by this set (buffer-local, `nowait`):

| Keys                    | Action                                  |
| ----------------------- | --------------------------------------- |
| `+` (global)            | Toggles the tree, revealing the current file |
| `<C-Home>` (global)     | Focuses the tree                        |
| `<CR>` / double-click   | Open                                    |
| `v` / `s`               | Open in vsplit / split                  |
| `>` / `<`               | Make the node root / go up a root       |
| `P`                     | Jump to parent                          |
| `<BS>`                  | Close the parent directory              |
| `E` / `W`               | Expand all / collapse all               |
| `h` / `gh`              | Toggle dotfiles / gitignored files      |
| `r`                     | Refresh                                 |
| `f` / `F`               | Start / clear the live filter           |
| `*`                     | Toggle bookmark                         |
| `x`                     | Toggle "only bookmarked" filter         |
| `a`                     | Create file or folder                   |
| `d`                     | Delete                                  |
| `m` / `M`               | Rename / rename full path               |
| `c` / `p`               | Copy / paste                            |
| `bd` / `bm`             | Delete / move bookmarked                |
| `y` / `Y` / `gy`        | Copy name / relative path / absolute path |
| `i`                     | Info popup                              |
| `?`                     | Help                                    |
| `q`                     | Close                                   |

### 3.4 Harpoon

[harpoon](https://github.com/ThePrimeagen/harpoon), `harpoon2` branch.

- Menu width is the editor width minus **4**, measured when the spec loads. Saves the list when the menu is toggled.

| Keys                     | Action                      |
| ------------------------ | --------------------------- |
| `<leader>H`              | Adds the file               |
| `<leader>h`              | Toggles the quick menu      |
| `<leader>1` … `<leader>5` | Jumps to file 1–5          |

### 3.5 Flash

[flash.nvim](https://github.com/folke/flash.nvim) with defaults, on `VeryLazy`.

| Keys            | Mode     | Action                        |
| --------------- | -------- | ----------------------------- |
| `s`             | n, x, o  | Jump                          |
| `S`             | n, x, o  | Treesitter select             |
| `r`             | o        | Remote flash                  |
| `R`             | o, x     | Treesitter search             |
| `<C-s>`         | c        | Toggles flash in `/` search   |

### 3.6 Search and replace

[grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim), header at most **80** wide.

- `<leader>sr` (n, v) opens a transient grug-far, prefilled with a `*.<ext>` files filter for the current file's extension.
- `q` closes it (1.7).

### 3.7 Tmux panes

[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) + [better-vim-tmux-resizer](https://github.com/RyanMillerC/better-vim-tmux-resizer). The same keys move between Neovim splits and tmux panes.

| Keys                                          | Mode     | Action                                   |
| --------------------------------------------- | -------- | ---------------------------------------- |
| `<C-Left>` `<C-Down>` `<C-Up>` `<C-Right>`    | n, v     | Move to the split/pane in that direction |
| `<S-Left>` `<S-Down>` `<S-Up>` `<S-Right>`    | n, i, v  | Resize the split/pane                    |

- Resizer default mappings are off. Resize steps: **4** horizontally, **8** vertically.
- Insert mode leaves insert, resizes, and re-enters insert. Visual mode reselects afterwards.

## 4. Syntax

### 4.1 Treesitter

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), **main** branch, `lazy = false`, `build = ':TSUpdate'`.

- Ensures 32 parsers (base list in `treesitter.lua`, the rest from `lang/*.lua`):
  - bash, c, cmake, comment, cpp, diff, dockerfile, git_rebase, gitattributes, gitcommit, gitignore, go, gomod, gosum, gowork, html, json, json5, latex, lua, make, markdown, markdown_inline, python, query, regex, rust, toml, typst, vim, vimdoc, yaml
- `config` calls `setup(opts)` then `install(ensure_installed)` on every start (a no-op once installed).
- A FileType autocmd whose **pattern is the list of installed parser names** turns on, per buffer:
  - highlighting (`vim.treesitter.start`, in a `pcall`)
  - Treesitter folds (1.5)
  - Treesitter indent (`indentexpr = nvim-treesitter.indentexpr()`)

### 4.2 Small highlights

- [mini.hipatterns](https://github.com/nvim-mini/mini.hipatterns) on `LazyFile`:
  - `FIXME`, `HACK`, `TODO`, `NOTE` get their own highlight groups.
  - Hex colors (`#rrggbb`) are painted with that color.

### 4.3 Context

- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) on `LazyFile`, `mode = 'topline'`: the enclosing function/class sticks to the top of the window.
- `<leader>ut` toggles it.

## 5. Code smarts

### 5.1 Language servers

[Mason](https://github.com/mason-org/mason.nvim) + [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) v2 + [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim).

- _mason-lspconfig_ loads on `BufReadPre` / `BufNewFile`, installs its list, and **automatically enables** every Mason-installed server (`automatic_enable = true`).
  - Servers: lua_ls, clangd, neocmake, dockerls, docker_compose_language_service, gopls, jsonls, taplo, yamlls, marksman, tinymist
- _mason-tool-installer_ loads on `LazyFile` and installs on start, with default update behavior:
  - Tools: clang-format, cpplint, cmakelang, cmakelint, hadolint, gofumpt, golangci-lint, goimports, stylua, markdownlint-cli2, markdown-toc
- After any Mason package installs, a `FileType` event is re-fired on the current buffer (after **100 ms**) so a new server attaches without reopening the file.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) supplies defaults. Its `config` loops over `opts.servers` and calls `vim.lsp.config(name, opts)` for each; it never calls `vim.lsp.enable` itself.
- The `'*'` entry gives every server file-rename support (`didRename` / `willRename`) and the LSP keymaps (5.7).

### 5.2 Diagnostics look

Not configured. `vim.diagnostic.config` is never called, so Neovim's defaults apply.

### 5.3 Per-server settings

Per-server settings live in `lua/plugins/lang/<lang>.lua` under the _nvim-lspconfig_ spec's `opts.servers.<name>`, merged with the `'*'` entry.

- **clangd**: see 10.1.
- **gopls**: see 10.4.
- **jsonls** / **yamlls**: schemas from SchemaStore, see 10.5.
- **lua_ls**: see 10.6.
- **tinymist**: see 10.8.
- **neocmake**, **dockerls**, **docker_compose_language_service**, **taplo**, **marksman**: defaults.

### 5.4 Completion

[blink.cmp](https://github.com/saghen/blink.cmp), version `1.*`, loads on `InsertEnter` / `CmdlineEnter`, `default` preset.

- Keys:
  - Preset: `<C-y>` accepts, `<C-Space>` opens/shows docs, `<C-e>` hides, `<C-n>` / `<C-p>` select, `<C-b>` / `<C-f>` scroll docs, `<C-k>` signature help.
  - `<Tab>` / `<S-Tab>` select next / previous (fall back when the menu is closed).
  - `<M-Right>` / `<M-Left>` jump forward / back through snippet placeholders.
  - `PageUp` / `PageDown` scroll the docs.
  - `<Up>` / `<Down>` don't touch the menu; they just move the cursor.
- _blink.cmp_ registers its capabilities with every server itself; nothing is merged by hand.
- Auto-brackets after functions. Docs pop up after **200 ms**.
- Menu labels are colorized by Treesitter for LSP items. Nerd Font variant `mono`.
- Ghost text in the buffer is **off** (default).
- Sources, in order: `lsp`, `path`, `snippets` ([friendly-snippets](https://github.com/rafamadriz/friendly-snippets)), `buffer`, `dictionary`, `emoji`.
  - **emoji** ([blink-emoji](https://github.com/moyiz/blink-emoji.nvim)): triggered by `:`, inserts the emoji itself, score **+15**, only in `gitcommit` and `markdown`.
  - **dictionary** ([blink-cmp-dictionary](https://github.com/Kaiser-Yang/blink-cmp-dictionary)): from **1** character, `force_fallback = true` (built-in matcher, no external `fzf`), no dictionary files configured.
- Command line: on. The menu opens by itself for `:` commands only, nothing preselected, with ghost text.

### 5.5 Pairs

- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) on `InsertEnter`.
  - Treesitter-aware (`check_ts`): no pairing inside Lua strings.
  - Fast-wrap (default `<M-e>`) label keys are `arstneiowfpluycdvh`.

### 5.6 Formatting

[conform.nvim](https://github.com/stevearc/conform.nvim) formats on save with a **500 ms** timeout. Loads on `BufWritePre` or `:ConformInfo`. Errors aren't notified.

| Filetypes                         | Formatter                               |
| --------------------------------- | --------------------------------------- |
| lua                               | stylua                                  |
| sh, bash                          | shfmt                                   |
| html, css, yaml, javascript, typescript | prettierd                         |
| json                              | prettier                                |
| markdown, markdown.mdx            | markdownlint-cli2, then markdown-toc (10.7 replaces prettierd) |
| c, cpp                            | clang-format                            |
| cmake                             | cmakelang                               |
| tex                               | latexindent                             |
| python                            | black                                   |
| go                                | goimports, then gofumpt                 |
| typst                             | typstyle, LSP preferred (`lsp_format = 'prefer'`) |

- Filetypes without a formatter fall back to the LSP, **except c and cpp**, which never use LSP formatting on save.
- Format-on-save runs when `vim.g.autoformat` **or** `vim.b.autoformat` is true.
  - `<leader>uf` toggles the global flag (and clears the buffer flag). `<leader>uF` toggles the buffer flag.
  - The toggles come from a global `toggle_autoformat(buf)` function in `formatting.lua`.
- `<leader>gf` (n, v, o) formats now, async, falling back to the LSP.

### 5.7 LSP keymaps

Defined in the `'*'` server's `keys` and set with `Snacks.keymap.set(..., { lsp = {} })`, so they're buffer-local and appear once any server attaches. Language-specific keys use the same mechanism, filtered to their server.

| Keys                    | Action                                      | Notes                                                        |
| ----------------------- | ------------------------------------------- | ------------------------------------------------------------ |
| `gd`                    | Goes to the definition                      | Through the picker, like `gr`, `gI`, `gy`.                   |
| `gD`                    | Goes to the declaration                     |                                                              |
| `gy`                    | Goes to the type definition                 |                                                              |
| `gr`                    | Lists references                            | `nowait`, so it doesn't wait on Neovim's built-in `gr*` keys. |
| `gI`                    | Lists implementations                       |                                                              |
| `gai` / `gao`           | Lists incoming / outgoing calls             |                                                              |
| `K`                     | Shows hover docs                            |                                                              |
| `gK`                    | Shows signature help                        | In insert, blink's `<C-k>`.                                  |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols            |                                                              |
| `<leader>ca`            | Shows code actions                          | Normal mode.                                                 |
| `<leader>rn`            | Renames the symbol                          |                                                              |
| `<leader>gf`            | Formats now                                 | 5.6.                                                         |
| `<leader>ch`            | Switches source/header                      | clangd only (10.1).                                          |
| `<leader>cP`            | Pins the main file                          | tinymist only (10.8).                                        |

### 5.8 Linting

[nvim-lint](https://github.com/mfussenegger/nvim-lint) on `LazyFile`.

- Runs on `BufEnter`, `BufWritePost`, `TextChanged`, only in modifiable buffers.
- Active linters: **go** → golangcilint, **dockerfile** → golangcilint (10.3).
  - c/cpp (cpplint), cmake (cmakelint) and markdown (markdownlint-cli2) entries exist but are commented out.
- `<leader>gl` lints now.

## 6. Git

### 6.1 Signs and blame

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) on `LazyFile`.

- Signs: `▎` for add, change, changedelete, untracked; the Nerd Font glyph `` (U+F0DA) for delete and topdelete. Staged signs use the same characters.
- `<leader>uG` toggles the signs.

Buffer-local keys:

| Keys                       | Action                                               | Notes                                        |
| -------------------------- | ---------------------------------------------------- | -------------------------------------------- |
| `]h` / `[h`                | Next / previous hunk                                 | In diff mode, falls back to `]c` / `[c`.     |
| `]H` / `[H`                | Last / first hunk                                    |                                              |
| `<leader>ga` (n, v)        | Stages the hunk (or selected lines)                  |                                              |
| `<leader>gr` (n, v)        | Resets the hunk                                      |                                              |
| `<leader>gu`               | Undoes the last stage                                |                                              |
| `<leader>gA`               | Stages the buffer                                    |                                              |
| `<leader>gR`               | Resets the buffer                                    |                                              |
| `<leader>gp`               | Previews the hunk inline                             |                                              |
| `<leader>gb`               | Toggles inline blame for the current line            |                                              |
| `<leader>gB`               | Shows full blame for the line in a float             |                                              |
| `<leader>ghd` / `<leader>ghD` | Diffs against the index / against `HEAD~`         |                                              |
| `ih` (o, x)                | Selects the hunk as a text object                    |                                              |

### 6.2 Diff overlay

Not used.

### 6.3 Diff view

Not used.

### 6.4 Lazygit

`<leader>lg` opens [lazygit](https://github.com/jesseduffield/lazygit) through _snacks.nvim_ with **default** settings (empty `lazygit = {}`).

- A float, with the theme synced from the colorscheme.
- Snacks sets lazygit's edit preset to `nvim-remote`, so `e` on a file opens it in this Neovim.

Lazygit's own config lives in `~/.config/lazygit/config.yml`, outside the Neovim config. It holds:

- Diffs render with `delta --dark --paging=never`, `colorArg: always`, `useConfig: false`.

### 6.5 Links

Not used.

### 6.6 Fugitive

- [vim-fugitive](https://github.com/tpope/vim-fugitive) on `LazyFile`, with no config or keymaps. Used via `:Git` / `:G` commands.

## 7. AI

Not used.

### 7.1 Copilot

Not used.

## 8. Agentic coding

Not used.

### 8.1 Copy paths for agents

Not used.

### 8.2 Helper keymaps

Not used.

## 9. Editing

### 9.1 Comments

- Neovim's built-in `gc` / `gcc` commenting, plus [Comment.nvim](https://github.com/numToStr/Comment.nvim) on `VeryLazy` for `gco`, `gcO`, `gcA`, and `gb` block comments.
  - Its `pre_hook` comes from [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) (`enable_autocmd = false`), so embedded languages get the right comment style.
- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) on `VeryLazy` (only on Neovim ≥ 0.10) improves `commentstring` for the built-in commenting.

### 9.2 Surround

[mini.surround](https://github.com/nvim-mini/mini.surround), lazy-loaded on its keys, all under `gs`:

| Keys        | Action                               |
| ----------- | ------------------------------------ |
| `gsa` (n, x) | Add surrounding                     |
| `gsd`       | Delete surrounding                   |
| `gsr`       | Replace surrounding                  |
| `gsf` / `gsF` | Find surrounding right / left      |
| `gsh`       | Highlight surrounding                |
| `gsn`       | Update `n_lines`                     |

### 9.3 Text objects

[mini.ai](https://github.com/echasnovski/mini.ai) on `VeryLazy`, searching **500** lines. Extra `a`/`i` objects:

| Key | Object                                                                   |
| --- | ------------------------------------------------------------------------ |
| `o` | Code block: Treesitter block, conditional, or loop                       |
| `f` | Function (Treesitter)                                                    |
| `c` | Class (Treesitter)                                                       |
| `t` | HTML/XML tag                                                             |
| `d` | Digits                                                                   |
| `e` | Word segment with case (camelCase / snake_case pieces)                   |
| `u` | Function call ("usage")                                                  |
| `U` | Function call, name without dots                                         |
| `G` | Whole buffer                                                             |

- Plus `ih` for git hunks (6.1).

### 9.4 Move lines

[mini.move](https://github.com/echasnovski/mini.move) on `VeryLazy`:

- `<M-Up>` / `<M-Down>` move the line (normal) or selection (visual) up/down.
- `<M-Left>` / `<M-Right>` move the selection left/right in visual mode.
- In normal mode, `<<` / `>>` are taken over to move the line left/right.

### 9.5 Substitute and exchange

[substitute.nvim](https://github.com/gbprod/substitute.nvim) on `BufReadPre` / `BufNewFile`, defaults.

| Keys            | Mode | Action                                          |
| --------------- | ---- | ----------------------------------------------- |
| `<leader>p`     | n    | Paste-over operator (replace a motion with the register) |
| `<leader>pp`    | n    | Paste over the line                             |
| `<leader>P`     | n    | Paste over to end of line                       |
| `<leader>p`     | x    | Paste over the selection                        |
| `gx`            | n, x | Exchange operator (do it twice to swap)         |
| `gxx`           | n    | Exchange the line                               |
| `gxc`           | n    | Cancel the exchange                             |

- `gx` replaces Neovim's built-in "open URL" key.
- While an exchange is pending, lualine shows it (2.4).

### 9.6 Dial

[dial.nvim](https://github.com/monaqa/dial.nvim) replaces `<C-a>` / `<C-x>` / `g<C-a>` / `g<C-x>` (n, v), picking the visual or normal variant from the current mode.

- **default** group: decimal (non-negative and signed), hex, octal, binary, dates `%m/%d/%Y`, `%H:%M`, `%H:%M:%S`, `first`…`tenth`, `Monday`…`Sunday` and lowercase, `January`…`December` and lowercase, `True`/`False`, `true`/`false`, `&&`/`||`. All cycle.
- Per-filetype groups (each also gets the whole default group appended):
  - **markdown**: `[ ]` ↔ `[x]`, and header level
  - **json**: semver
  - **lua**: `and` ↔ `or` (whole words)
  - **python**: `and` ↔ `or`
- The filetype → group map is stored in `vim.g.dials_by_ft`.

### 9.7 Annotations

- [neogen](https://github.com/danymat/neogen) with defaults. `<leader>cn` generates a doc comment for the thing under the cursor.

### 9.8 Indent detection

- [vim-sleuth](https://github.com/tpope/vim-sleuth) on `LazyFile` sets `shiftwidth` / `expandtab` from the file's existing style.

## 10. Languages

Each file in `lua/plugins/lang/` only extends the shared specs.

### 10.1 C / C++

- Server **clangd**, installed by Mason, with:
  - `cmd`: `clangd --background-index --clang-tidy --header-insertion=iwyu --completion-style=detailed --function-arg-placeholders --fallback-style=llvm`
  - root markers: `compile_commands.json`, `compile_flags.txt`, `configure.ac`, `Makefile`, `configure.in`, `config.h.in`, `meson.build`, `meson_options.txt`, `build.ninja`, `.git`
  - `offsetEncoding = utf-16`, init options: placeholders, complete unimported, file status
  - `<leader>ch` switches source/header
- Mason tools: clang-format, cpplint. Format with clang-format; no LSP fallback on save.

### 10.2 CMake

- Parser `cmake`. Server **neocmake**. Mason tools: cmakelang, cmakelint.
- Formatter: cmakelang (5.6).

### 10.3 Docker

- Parser `dockerfile`. Servers **dockerls** and **docker_compose_language_service**.
- Mason tools: hadolint, gofumpt, golangci-lint.
- Lints Dockerfiles with **golangcilint**.

### 10.4 Go

- Parsers `go`, `gomod`, `gowork`, `gosum`. Server **gopls** with:
  - `gofumpt`, `staticcheck`, `semanticTokens`, placeholders, complete unimported
  - code lenses: generate, regenerate_cgo, run_govulncheck, test, tidy, upgrade_dependency, vendor (gc_details off)
  - all inlay hints on: variable types, composite literal fields/types, constant values, type parameters, parameter names, range variable types
  - analyses: nilness, unusedparams, unusedwrite, useany
  - directory filters skip `.git`, `.vscode`, `.idea`, `.vscode-test`, `node_modules`
- Mason tools: goimports, gofumpt, golangci-lint. Format: goimports then gofumpt. Lint: golangcilint.

### 10.5 JSON / TOML / YAML

- Parsers `json5`, `toml`, `yaml`. Servers **jsonls**, **taplo**, **yamlls**.
- [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim), lazily required in each server's `before_init`.
- **jsonls**: SchemaStore schemas appended; format and validate on.
- **yamlls**: SchemaStore schemas merged in; built-in schema store off (`url = ''`); `keyOrdering` off; format and validate on; Red Hat telemetry off; folding range capability set to line-folding only.

### 10.6 Lua

- Server **lua_ls**: call snippets `Replace`, LuaJIT runtime, `checkThirdParty` off, library = luv types + the whole Neovim runtime path, `missing-fields` diagnostic off, its formatter off (stylua does it).
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) on `ft = lua`: adds luv types when `vim.uv` appears and _snacks.nvim_ types when `Snacks` appears. Also lists `cmd = 'LavyDev'`.
- Mason tool: stylua.

### 10.7 Markdown

- Server **marksman**. Mason tools: markdownlint-cli2, markdown-toc. Format with both, in that order.
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) for `markdown`, `norg`, `rmd`, `org`, `codecompanion`:
  - Code blocks: block width, right pad **1**, language label with a space border and no left/right caps.
  - No sign column marks. LSP completion for its checkboxes/callouts on.
  - `<leader>um` toggles rendering.
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim): `<leader>cp` (markdown only) toggles a browser preview.
- Markdown buffers get wrap and spell (1.7).

### 10.8 Typst

- Parser `typst`. Server **tinymist**, `single_file_support` on (works outside git repos), `formatterMode = typstyle`.
- `<leader>cP` pins the current file as the main file through `tinymist.pinMain`.
  - Written with `LazyVim.lsp.execute` and `LazyVim.info` (not defined in this config).
- [typst-preview.nvim](https://github.com/chomosuke/typst-preview.nvim) using Mason's `tinymist` binary: `<leader>cp` (typst only) toggles the live preview.
- Format with typstyle, LSP preferred. Typst buffers get wrap and spell (1.7).

## 11. Sessions

### 11.1 Persistence

[persistence.nvim](https://github.com/folke/persistence.nvim) on `BufReadPre`, defaults. Saves a session per directory on exit once a file has been opened.

| Keys          | Action                           |
| ------------- | -------------------------------- |
| `<leader>qs`  | Restores the session for the cwd |
| `<leader>qS`  | Picks a session                  |
| `<leader>ql`  | Restores the last session        |
| `<leader>qd`  | Stops saving the current session |
