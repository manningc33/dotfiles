# Manning's dotfiles

## How to setup

To setup dotfiles run the following commands: 
 ```bash
cd ~
git clone https://github.com/manningc33/dotfiles.git
cd dotfiles
. ./setup.sh -f
```


## vim features
| keybind             | info |
| ---                 | --- |
| Ctrl + ←↑↓→         | navigate between splits/panes (works w/ tmux) |
| Alt + ←↑↓→          | resize splits/panes (works w/ tmux) | 
| \<Leader\>f or '\\' | fzf files in current dir |
| ctrl + '\\'         | fzf in home dir |
| \<Leader\>b         | fzf current buffers |
| \<Leader\>l         | fzf current lines of open buffers |
| \<Leader\>r         | replace previously highlighted search in file, can use visual mode to select a range|
| c*                  | replace current word or visual selection and use . to repeat on next occurance(s) |

## Dependencies (need to be installed manually) 
- [bat](https://github.com/sharkdp/bat?tab=readme-ov-file#installation) (for colored previews, colorscheme downloaded automatically by dot setup)
- ripgrep (for multi-file search) 

## To-do 
- figure out ALE
- figure out polyglot 
- make readme look better
- git integration: fugitive, set up vim nvim parity with gitgutter and gitsigns 
- look in to integrating lazy-git with bat for colored display
- start defining own prompt, move away from lightline
- tmux nerd font dependency 