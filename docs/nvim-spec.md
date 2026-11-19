## 0. Prerequisites

### 0.1 Neovim

- [Neovim](https://neovim.io/doc/install/?ref=devas.life) **0.12** or newer.
  - The config relies on built-ins that landed in 0.12: `vim.pack`, `vim.lsp.enable`, and the ui2 message UI.

### 0.2 CLI tools

| Tool | Why |
| --- | --- |
| `git` | `vim.pack` clones plugins with it |
| `tree-sitter` CLI + C compiler | _nvim-treesitter_'s main branch builds parsers locally |
| `curl` and `tar` | Parser and _blink.cmp_ binary downloads |
| Node.js + npm | _Mason_ installs most language servers through npm |
| `ripgrep` and `fd` | Back the text search and the file finder |
| `lazygit` and `git-delta` | The git UI and its diff renderer |

### 0.3 Font

- A Nerd Font.
  - Icons appear in the tabline, bufferline, statusline, completion menu, and file explorer, so a plain font shows boxes.

### 0.4 Git

- The config folder is a git repository.
- `.gitignore` lists `nvim-pack-lock.json`.

## 1. Foundation

### 1.0 Start a session

### 1.1 Layout

- `~/.config/nvim`: the config root folder
  - `init.lua`: enables `vim.loader` for faster startup, then requires these files directly, in order:
        1. `config.options`, `.builtins`, `.keymaps`, `.autocmds`
        2. `plugins`
  - `lua/config/`: plain Neovim settings, one file per name above
  - `lua/util/`: shared helpers
    - `init.lua`: returns a table of helper modules, empty for now.
      - Later steps add modules like `util/editor.lua`, exposed as `editor`.
  - `lua/plugins/`
    - `init.lua`: installs every plugin with one `vim.pack.add({ ... })`, then requires each group folder (`require("plugins.ui")`), in order
    - Each plugin group gets its own directory (`ui/`) with an `init.lua` that sets up the group's plugins in load order. A plugin's `setup()` goes inline there unless its config has autocmds or user commands, or is longer than 15 lines; then it gets its own file (`ui/<plugin>.lua`), required from `init.lua` at its place in the order.
    - No named helper functions in `plugins/`; they live in `util/` (e.g. `util/lualine.lua`). Short inline callbacks passed to an option or keymap are fine. Exceptions: `gh` in `plugins/init.lua` and `map` in `plugins/keymaps.lua`.
    - `lang/`: each language is set up in one place that names it and lists its parsers, formatters, servers, and any extra Mason tools. Small languages sit inline in `lang/init.lua`; a big one gets `lang/<language>.lua`, with anything extra it needs alongside.
    - `keymaps.lua`: every keymap that uses a plugin, required last so all plugins are set up first. Group files hold no keymaps, except keys a plugin takes in its `setup()` (e.g. oil's buffer keys).
      - Keys for one filetype go in its `ft_keys` table, mapped per buffer.
      - Keys that need a language server go in that server's `keys` in `after/lsp/<server>.lua`, mapped when it attaches.

### 1.2 Leader and basics

- Leader and local leader are **Space**.
- Clipboard is `unnamedplus`, so yank and paste go through the system clipboard.
- Indent is **4 spaces**:
  - `tabstop`, `shiftwidth`, and `softtabstop` are all **4**
  - `expandtab`, and `smartindent` are **on**
- `-` counts as part of a word, so `foo-bar` is one word.
  - Fits CSS classes and kebab-case names.

### 1.3 Look of the buffer

- **Hybrid** line numbers: `number` + `relativenumber` **on**, so the cursor line shows its real number.
- `cursorline` **on**. No wrap, `scrolloff` **10**, `sidescrolloff` **8**.
- Wrapped lines keep their indent, and list items wrap under their text (`breakindent`).
- `signcolumn` **always on**.
  - Text doesn't jump when git or diagnostic marks appear.
- `cmdheight` **0** and one global statusline (`laststatus` **3**).
  - Maximizes vertical space.
- **Rounded** borders on every float (`winborder`).
- Popup menu: at most **10** rows, slightly see-through (`pumheight` **10**, `pumblend` **10**).
- Matching brackets flash briefly (`showmatch` **on**, `matchtime` **2**).
- `title` **on**, so the terminal tab shows the file name.
- Diagonal `╱` fill in empty diff areas.

### 1.4 Search, files, undo

- `ignorecase` + `smartcase` **on**: case-insensitive until a capital letter is typed.
- `path` adds `**`, so `:find` searches subfolders.
- `:` completion:
  - `wildmode` is `longest:full,full`
  - `wildignore` skips `*/node_modules/*`, `*.o`, `*.obj`, `*.pyc`, `*.class`, `*.jar`
- `swapfile` and `writebackup` **off**.
- Persistent undo (`undofile` **on**) lives in `~/.cache/nvim/undodir`.
  - Undo survives closing the file. Swap files only get in the way.
- Snappier timing: `updatetime` **300**, `timeoutlen` **500**, `ttimeoutlen` **0**.
  - Faster CursorHold events, and key sequences resolve without lag.

### 1.5 Splits and folds

- New splits open **below** and to the **right**.
- Folds come from **Treesitter**, with `foldlevel` **99**.
  - Everything starts unfolded, and folds can still be closed by syntax.

### 1.6 Messages

Neovim 0.12's experimental **ui2** handles messages. It's turned on in `config/builtins.lua`.

- Short messages: corner popup up to **30%** of the screen tall, gone after **5 seconds**.
- Long output (errors, `:ls`, `:verbose`, shell commands, progress): a scrollable pager up to **half** the screen.
- Search count, search pattern, completion, `:` completion list, and confirm prompts stay in the command line.
- Output of a command I type goes to the command line too, whatever its kind.
  - It expands over the bottom of the screen until the next key.
  - `Enter` moves it into the pager.

[tiny-cmdline.nvim](https://github.com/rachartier/tiny-cmdline.nvim?ref=devas.life) shows the `:` command line as a floating box, centered left to right, **20%** from the top. It's set up in `plugins/ui/`.

- With `cmdheight` 0, the command line needs somewhere to appear, and near the top is where the eyes already are.

### 1.7 Autocmds

- Yanked text flashes briefly
- Only the active window shows the cursorline.
- Reopening a file puts the cursor back where it was (the `"` mark), except in `gitcommit`.
- On `FocusGained`, `TermClose`, `TermLeave`, reloads files changed outside Neovim (skipped for `nofile` buffers).
- Wrap and spell: `text`, `plaintex`, `typst`, `gitcommit`, `markdown` buffers get `wrap` and `spell` on.

### 1.8 Core keymaps

| Keys | Action | Notes |
| --- | --- | --- |
| `x` | Deletes without copying | |
| `<leader>d` / `<leader>D`, `<leader>c` / `<leader>C`, `<leader>p` / `<leader>P` | Delete, change, and paste without touching the yank register | The yanked text stays safe while editing around it. |
| `dd` | Deletes the line; on a blank line, doesn't copy it | Deleting empty lines never clobbers the register. |
| `dw` | Deletes the word backwards without copying | |
| `<leader>-` / `<leader>\|` | Split below / right | |
| `<leader>wd` | Closes the window (`<C-w>c`) | |
| `Tab` / `Shift-Tab` | Cycle tabs | |
| `<S-Tab>` (insert) | Dedents (`<C-d>`) | |
| `J` | Joins lines, cursor stays put (`mzJ\`z`) | |
| `<C-d>` / `<C-u>` | Half-page scroll, then center | |
| `PageDown` / `PageUp` | Same as `<C-d>` / `<C-u>`, centered, folds opened | |
| `n` / `N` | Next/prev match, centered, folds opened | |
| `<Esc>` | Clears search highlights | |
| `<` / `>` (visual) | Indent and keep the selection | |
| `<leader>W` | Saves without autocmds (`:noautocmd w`) | Skips format-on-save. |
| `<leader>*` | word quick replace. Starts `:%s/\<word\>/word/gI` for the word under the cursor, cursor on the replacement | |
| `<leader>o` / `<leader>O` | Open a line below or above without continuing a comment (`o<Esc>^Da`) | |
| `<Home>` (n, v, i) | Goes to the first non-blank; pressed again, to column 0. Works on what's on screen: the displayed row with wrap on, the part of the line in view with wrap off | Smart home. Operator-pending `<Home>` is `^`. Use `0` for the real line start. |
| `<End>` (n, v, i) | Goes to the end of what's on screen: the displayed row with wrap on, the last visible character with wrap off | With wrap off, pressing again at the edge scrolls right. Use `$` for the real line end. |
| `<leader>tt` `<leader>td` | New tab / close tab | |
| `<leader>to` | Close other tabs (`:tabonly`) | |

Arrow keys navigate. `<Up>` / `<Down>` move by screen line when wrap is on, in normal, visual, and insert mode; with a count they move real lines. `<Left>` / `<Right>` at a line's start or end continue onto the previous or next line.

### 1.9 Close hidden buffers

- `<leader>bo` closes every hidden buffer, except unsaved ones.
- `<leader>bd` deletes the current buffer and keeps the window open.

## 2. Look & feel

### 2.1 Colorscheme

- [catppuccin](https://github.com/catppuccin/nvim), default flavour (mocha), **transparent** background

### 2.2 Icons

- [mini.icons](https://github.com/nvim-mini/mini.icons?ref=devas.life), also mocking [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons?ref=devas.life)
  - One icon source for every plugin.

### 2.3 Tabline

A custom tabline in `util/tabline.lua`, with no plugin.

- Shown only when there are **2** or more tabs.
- Each tab shows the active window's file name with its icon, padded with **3** spaces, between slanted separators.
  - Both edges slant outward going down, so each tab is a trapezoid, wider at the bottom:
- Colors from the catppuccin palette:
  - The icon takes the tab's text color.
  - The separators take the tab's color on a transparent background, and so does the empty area after the last tab.
- Names longer than **20** characters are cut to **17** plus `…`.
- Unsaved tabs show `[+]` before the icon.
- terminals show `[terminal]` and empty buffers `[no name]`, with no icon.

### 2.4 Statusline

[lualine](https://github.com/nvim-lualine/lualine.nvim?ref=devas.life), one global bar, theme `auto`.

| Section | Content |
| --- | --- |
| a | Mode |
| b | Git branch |
| c | Project root name (only when it differs from cwd), filetype icon, pretty path |
| x | anything in progress (just macro recording register for now), diagnostics, git diff counts, filetype |
| y | Progress |
| z | line:column |

- The project root is found by searching upward for `.git`, `lua`, `package.json`, `Makefile`, `Cargo.toml`, `go.mod`, or `pyproject.toml`.
- Extensions: `man`, `quickfix`, `Mason`
- Refreshes on cursor move and macro start/stop.
  - The recording indicator replaces the hidden command line.

### 2.5 Window labels

- [incline.nvim](https://github.com/b0o/incline.nvim?ref=devas.life) shows a filename tag with an icon in the top-right corner of each window, plus `[+]` when unsaved.
  - With a single global statusline, each split still needs to say which file it holds, then the [nvim-navic](https://github.com/SmiteshP/nvim-navic) breadcrumb. These can be included in one file if appropriate.
  - `<leader>un` disables navic breadcrumbs
  - The breadcrumb shows at most **5** levels.
- The tag hides when the cursor overlaps it.

### 2.6 Snacks

[snacks.nvim](https://github.com/folke/snacks.nvim?ref=devas.life) provides the notifier, indent guides, statuscolumn, and word highlighting.  
Later steps turn on more of it, like the picker and the lazygit integration, toggle.

- **Words**: the word under the cursor is highlighted everywhere. `]]` / `[[` jump between occurrences.
  - It needs a language server, so it works after step 4.2.
- **Smooth scroll** is **off**.
  - Scrolling should feel instant.
- **Indent guides**: no animation, no scope highlighting

### 2.7 UI toggles

Every `<leader>u*` key is a `Snacks.toggle`, which shows its on/off state in which-key (added later).

| Keys | Toggles |
| --- | --- |
| `<leader>us` | Spelling |
| `<leader>uw` | Wrap |
| `<leader>uL` | Relative number |
| `<leader>ul` | Line numbers |
| `<leader>ud` | Diagnostics |
| `<leader>uc` | `conceallevel` (0 ↔ 2) |
| `<leader>uT` | Treesitter highlighting |
| `<leader>uh` | Inlay hints |
| `<leader>ug` | Indent guides |
| `<leader>un` | navic breadcrumb (2.5) |
| `<leader>wm` | Zoom the window |

### 2.8 Small highlights

- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim?ref=devas.life) highlights `TODO`, `FIXME`, and the like, with defaults.
- [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors?ref=devas.life) paints hex, rgb, hsl, ANSI, and CSS variable colors as backgrounds. Tailwind is off.
  - Neovim's LSP document colors are turned off, so colors aren't painted twice.

### 2.9 Which-key

[which-key.nvim](https://github.com/folke/which-key.nvim) popup after **500 ms**.

- Groups: `<leader>l` LSP/code (n, x), `<leader>f` find/picker, `<leader>g` git, `<leader>u` toggle, `<leader>t` tabs, `[` prev, `]` next, `z` fold, `<leader>w` windows (**proxy** for `<C-w>`), `<leader>b` buffers, `<leader>y` special copy (n, x), `gc` comment
- `<leader>?` shows buffer-local keymaps.

## 3. Navigating

### 3.1 Picker

The _snacks.nvim_ picker.

| Keys | Action | Notes |
| --- | --- | --- |
| `\` | Finds files, including hidden ones | Dotfiles like `.github/` and `.env.example` are part of real projects. |
| `<leader>fg` | Live-greps, including hidden files | In visual mode, greps the selection. |
| `<leader>fw` (n, x) | Greps the word under the cursor, or the selection | |
| `<leader>ff` | Reopens the last picker | |
| `<leader>fb` | Lists open buffers | Jumps to a window that already shows the buffer. |
| `<leader>fd` | Lists diagnostics | |
| `<leader>fn` | Shows notification history | |
| `<leader>fh` | Lists git hunks | |
| `<leader>fc` | Lists changed files (git status) | Includes staged and untracked files. |
| `<leader>fk` | keymaps | |
| `<leader>fe` | Emoji and icons picker | Inserts at the cursor. |
| `<leader>fr` | Lists recent files | |
| `<leader>fu` | Browses undo history | |
| `<leader>f/` | Searches lines in the current buffer | |

### 3.2 File explorer

[oil.nvim](https://github.com/stevearc/oil.nvim?ref=devas.life) replaces netrw and shows hidden files.

- The directory is a buffer, so renaming, moving, and deleting files is plain text editing followed by `:w`.
- Columns: icon, permissions, size, modified time. `gd` toggles a detail view icon only
- Renaming a file asks the LSP to update imports and saves those edits automatically.
- Deletes go to the **trash**. Simple edits skip the confirm prompt. Watches the disk for changes.
- In the tabline (2.3), an oil tab shows its directory (`~/foo`) with no icon.
  - Paths longer than **20** characters are cut from the left to `…` plus the last **17**.

| Keys | Action | Notes |
| --- | --- | --- |
| `-` | Opens oil as a centered float with a live preview | At most **200** columns wide, with rounded corners. |
| `<leader>_` | Opens oil in the current window | Global key. |
| `h` | Toggles hidden files | |
| `K` | Preview | |
| `q` / `<Esc><Esc>` | Closes oil | |
| `gd` | Toggles detail columns | |

### 3.3 Flash

[flash.nvim](https://github.com/folke/flash.nvim) for navigating within editor

| Keys | Mode | Action |
| --- | --- | --- |
| `s` | n, x, o | Jump |
| `S` | n, x, o | Treesitter select |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggles flash in `/` search |

### 3.4 Tmux panes

[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) + its [tmux backend](https://github.com/smart-splits-nvim/backend-tmux). The same keys move between Neovim splits and tmux panes.

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-Left>` `<C-Down>` `<C-Up>` `<C-Right>` | n, v | Move to the split/pane in that direction |
| `<S-Left>` `<S-Down>` `<S-Up>` `<S-Right>` | n, i, v | Resize the split/pane |

## 4. Code smarts (languages specific)

### 4.1 Treesitter

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter?ref=devas.life), main branch.

- Ensures 49 parsers, each listed with its language (1.1); general-purpose ones (comment, diff, regex, query, …) are their own group:
  - bash, c, cmake, comment, cpp, css, diff, dockerfile, fish, git_rebase, gitattributes, gitcommit, gitignore, go, gomod, gosum, gowork, graphql, html, http, java, javascript, jsdoc, json, json5, latex, lua, luadoc, luap, make, markdown, markdown_inline, php, printf, python, query, regex, rust, scss, sql, svelte, toml, tsx, typescript, typst, vim, vimdoc, xml, yaml
- A FileType autocmd starts highlighting and Treesitter indent whenever a parser exists.
- `:TSUpdate` runs on the `PackChanged` event.
  - Parsers stay in sync with the plugin version.

### 4.2 Language servers

[Mason](https://github.com/mason-org/mason.nvim?ref=devas.life) + [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim?ref=devas.life) install on start, and never auto-update:

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig?ref=devas.life) supplies defaults.

- Each language turns on its own servers with `vim.lsp.enable`.
- Every server gets file-rename support (`didRename` / `willRename`).
- Every server also gets _blink.cmp_'s completion capabilities, once blink is added (8.1).

### 4.3 Formatting

[conform.nvim](https://github.com/stevearc/conform.nvim?ref=devas.life) formats on save with a **1000 ms** timeout, falling back to the LSP. Formatters per filetype are listed with each language (1.1).

- `<leader>uf` toggles format on save globally
- `<leader>uF` toggles format on save for buffer

### 4.4 Linting

No linting plugin: linters run as language servers (clang-tidy through clangd, shellcheck through bashls, golangci-lint through golangci_lint_ls).

- `<leader>ll` lints now.

### 4.5 LSP keymaps

For every filetype, language specific keymaps will be defined in 4.6

| Keys | Action | Notes |
| --- | --- | --- |
| `gd` | Goes to the definition | Through the picker, like `gD`, `gy`, and `gr`. |
| `gD` | Goes to the declaration | |
| `gy` | Goes to the type definition | |
| `gr` | Lists references | |
| `gI` | Lists implementations | |
| `gai` / `gao` | Lists incoming / outgoing calls | |
| `K` | Shows hover docs | |
| `gK` / `<C-k>` (insert) | Show signature help | |
| `<leader>la` | Shows code actions | |
| `<leader>lr` | Renames the symbol | |
| `<leader>lR` | Renames the file with import updates | |
| `<leader>ls` / `<leader>lS` | Document / workspace symbols | |
| `]d` / `[d` | Next / previous diagnostic | Neovim's built-in keys. |
| `<leader>ld` | Shows the line's diagnostics in a float | |
| `<leader>lf` | Formats now | |
| `<leader>li` | Shows LSP info | |

### 4.6 Per-language settings

Per-server settings live in `after/lsp/<name>.lua`.  
Neovim 0.12 merges these automatically, so there's no setup boilerplate.

For per language settings please view section 9.  

### 4.7 Diagnostics look

- Underlined, not updated while typing, sorted by severity.
- Inline text: `● message`, with the source only when there are several.
- Gutter icons come from the shared icon set.

For example, typing `const x: number = 'a'` in a TSX file:

- The error is underlined, with `● Type 'string' is not assignable…` inline and an icon in the gutter.
- The line also has a "never read" hint, but the gutter shows the error icon, since they are sorted by severity.
- oxlint flags the unused `x` too, so each message shows its source (`ts`, `oxc`). note: this spec might not include oxlint, but the principle still applies

## 5. Git

Since I mostly review code written by my agent now, this is the part of the setup I use the most.

### 5.1 Signs and blame

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim?ref=devas.life) with defaults.

- `<leader>uG` toggles the signs.

| Keys | Action | Notes |
| --- | --- | --- |
| `<leader>gb` | Blames the line | |
| `<leader>gB` | Blames the buffer | |
| `<leader>gp` | Previews the hunk inline | |
| `<leader>ga` | Stages or unstages the hunk | |
| `<leader>gA` | Stages or unstages the buffer | |
| `<leader>gr` / `<leader>gR` | Resets the hunk / the buffer | |
| `<leader>go` | Opens the file as of the commit that last touched the line, in a new tab | Shows the context of an old change without leaving the editor. |
| `<leader>gd` | Toggles a diff overlay: removed lines shown inline above each change | |
| `]h` / `[h` | Jump between hunks | |

### 5.2 Diff view

[codediff.nvim](https://github.com/esmuellert/codediff.nvim?ref=devas.life) for side-by-side diffs and history.  
I use it when my agent makes a lot of changes in the codebase.

- Explorer: **tree** view, **50** columns wide, opens files as the cursor moves, shows +/- line stats.
- Compact mode: only changes plus **8** context lines, with folds synced across panes.

| Keys | Action |
| --- | --- |
| `<leader>gv` | Toggles the diff view |
| `<leader>gh` | Shows the current file's history |
| `<leader>gH` | Shows the repo history |

### 5.3 Lazygit

`<leader>gg` opens [lazygit](https://github.com/jesseduffield/lazygit?ref=devas.life) in a float through _snacks.nvim_, with the theme synced and the active border in the WarningMsg color.

Pressing `e` on a file closes lazygit and opens the file in the window it was launched from, through `$NVIM` and `nvim --server --remote`.

- `<leader>gg` remembers the current window; `e` closes lazygit and opens the file in that window, with the cursor in the file.
- Not a new tab and not a nested Neovim. Outside Neovim, it just runs `nvim <file>`.

Lazygit's own config lives in `~/.config/lazygit/config.yml`, outside the Neovim config. _snacks.nvim_ loads it together with the synced theme. It holds:

- Diffs render with `delta --dark --paging=never`, `colorArg: always`, `useConfig: false`.

### 5.4 Links

- [gitlinker.nvim](https://github.com/linrongbin16/gitlinker.nvim?ref=devas.life): `:GitLink` copies a GitHub URL for the current line, or the selected range. Mapped to `<leader>yg` (7.2).

## 6. AI Co

### 6.1 Copilot

[copilot.lua](https://github.com/zbirenbaum/copilot.lua?ref=devas.life) with auto-trigger on, enabled in Markdown and help too.

- Notes and docs benefit from suggestions as much as code does.
- Requires `:Copilot auth` once.
- On macOS, the terminal needs Option as Alt.

The keys work in insert mode:

| Keys | Action |
| --- | --- |
| `<C-l>` | Accepts the suggestion |
| `Alt-l` | Accepts a word |
| `Alt-Shift-l` | Accepts a line |
| `Alt-]` / `Alt-[` | Cycle suggestions |
| `<C-]>` | Dismisses the suggestion |

> 📷 Frame: A Copilot suggestion as ghost text

## 7. Agentic coding

These are small helpers for passing context from Neovim to an agent.

### 7.1 Copy paths for agents

| Keys | Action | Notes |
| --- | --- | --- |
| `<leader>yf` / `<leader>yF` (n, x) | Copies the current file's path, relative to cwd / absolute | |
| `<leader>yl` / `<leader>yL` (n, x) | Same, with `#L<line>`, or `#L<a>-L<b>` for a visual selection | e.g. `lua/craftzdog/config/options.lua#L12` |

- Both show the copied text in a notification.
  - Pasting the path into an agent's prompt points it at the exact line.

### 7.2 Helper keymaps

| Keys | Action | Notes |
| --- | --- | --- |
| `<leader>yc` (visual) | Copies the selection as a Markdown code block with `filename="…"` and `line=…` attributes | The same format Inkdrop uses for code-block attributes. Short language names (`tsx`, `jsx`, `ts`, `js`). |
| `<leader>yg` (n, x) | Copies a GitHub permalink for the line or selected range (`:GitLink`, 5.4) | |

## 8. Editing

### 8.1 Completion

[blink.cmp](https://github.com/saghen/blink.cmp?ref=devas.life), version `^1`, `default` preset: `<C-y>` accepts; Enter is always a new line.

- Auto-brackets after functions. Docs pop up after **200 ms**.
- Menu items are colorized by Treesitter, with kind icons from the shared icon set.
- Ghost text is **off**.
  - Copilot already shows inline suggestions, and two ghost texts would clash.
- In the command line, the menu opens by itself for `:` commands only, with nothing preselected, can have ghost text (copilot won't be enabled for commandline).
- Sources: blink's defaults (`lsp`, `path`, `snippets`, `buffer`).
- Prose filetypes only (`text`, `plaintex`, `typst`, `gitcommit`, `markdown`, the same list as 1.7) also get these; code never does:
  - **spell** ([blink-cmp-spell](https://github.com/ribru17/blink-cmp-spell)): suggestions from Neovim's spell dictionary.
  - **emoji** ([blink-emoji](https://github.com/moyiz/blink-emoji.nvim)): `:` triggers emoji completion, score offset **50** so emoji rank above other matches.
- Keys (don't type out what is already defaulted):
  - Preset: `<C-y>` accepts, `<C-Space>` opens/shows docs, `<C-e>` hides, `<C-n>` / `<C-p>` select, `<C-b>` / `<C-f>` scroll docs, `<C-k>` signature help.
  - `<Tab>` / `<S-Tab>` select next / previous (fall back when the menu is closed).
  - `<M-Right>` / `<M-Left>` jump forward / back through snippet placeholders.
  - `PageUp` / `PageDown` scroll the docs.
  - `<Up>` / `<Down>` don't touch the menu; they just move the cursor.

### 8.2 Pairs

[nvim-autopairs](https://github.com/windwp/nvim-autopairs)

- Treesitter-aware (`check_ts`): no pairing inside Lua strings.
- Fast-wrap (default `<M-e>`) label keys are `arstneiowfpluycdvh`.

### 8.3 Comments

- Neovim's built-in `gc` / `gcc` commenting (Treesitter-aware for embedded languages).
- `gco` / `gcO` add a comment line below / above; `gcA` adds a comment at the end of the line.

### 8.4 Move lines

[mini.move](https://github.com/echasnovski/mini.move):

- `<M-Up>` / `<M-Down>` move the line (normal) or selection (visual) up/down.
- `<M-Left>` / `<M-Right>` move the selection left/right in visual mode.
- In normal mode, `<<` / `>>` are taken over to move the line left/right.

### 8.5 Dial

[dial.nvim](https://github.com/monaqa/dial.nvim) replaces `<C-a>` / `<C-x>` / `g<C-a>` / `g<C-x>` (n, v), picking the visual or normal variant from the current mode.

- **default** group: decimal (non-negative and signed), hex, octal, binary, dates `%m/%d/%Y`, `%H:%M`, `%H:%M:%S`, `first`…`tenth`, `Monday`…`Sunday` and lowercase, `January`…`December` and lowercase, `True`/`False`, `true`/`false`, `&&`/`||`. All cycle.
- Per-filetype groups (each also gets the whole default group appended):
  - **markdown**: `[ ]` ↔ `[x]`, and header level
  - **json**: semver
  - **lua**: `and` ↔ `or` (whole words)
  - **python**: `and` ↔ `or`
- The filetype → group map is stored in `vim.g.dials_by_ft`.

### 8.6 Indent detection

[guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) used to match each files' existing indentation (width, tabs or spaces).

## 9. Languages

### 9.1 Lua

- Parsers: lua, luadoc, luap.
- Format: stylua.
- Server **lua_ls**: LuaJIT runtime, knows the Neovim runtime and luv types, `Snacks` and `MiniIcons` known as globals, call snippets `Replace`, `checkThirdParty` off, `missing-fields` diagnostic off, its own formatter off.

### 9.2 C / C++

- Parsers: c, cpp, doxygen.
- Format: clang-format.
- Server **clangd**: detailed completion (each overload its own item), clang-tidy diagnostics. Root markers: lspconfig's defaults plus `meson.build` and `build.ninja`.
- `<leader>lh` switches between source and header.

### 9.3 CMake

- Parsers: cmake.
- Format: cmake_format.
- Server **neocmake** with defaults.

### 9.4 Go

- Parsers: go, gomod, gosum, gowork.
- Format: goimports, then gofumpt.
- Server **gopls**: staticcheck, completes unimported packages, function placeholders, and every inlay hint (shown with `<leader>uh`).

### 9.5 Markdown

- Parsers: markdown, markdown_inline.
- Format: markdownlint-cli2.
- Server **marksman** with defaults.
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) renders markdown buffers in place:
  - Code blocks: block width, right pad **1**, language label with a space border and no left/right caps.
  - No sign column marks. Its LSP completion (checkboxes, callouts) on.
  - `<leader>um` toggles rendering.
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim): `<leader>lp` (markdown only) toggles a browser preview.

### 9.6 Shell

- Parsers: bash.
- Format: shfmt (sh, bash).
- Server **bashls** with defaults; its diagnostics come from shellcheck.
- Extra Mason tools: shellcheck.

### 9.7 Config files (JSON, YAML, TOML)

- Parsers: json, json5, yaml, toml.
- Servers **jsonls**, **yamlls**, **taplo**; each also formats its files.
- [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) supplies JSON and YAML schemas (completion, hover, validation); yamlls's own schema download is off.
