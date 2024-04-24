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
| '\\'                | fzf files in current dir |
| ctrl + '\\'         | fzf in home dir |
| \<Leader\>b         | fzf current buffers |
| \<Leader\>l         | fzf current lines of open buffers |
| \<Leader\>r         | replace previously highlighted search in file, can use visual mode to select a range |
| \<Leader\>f         | live grep through entire directory | 
| c*                  | replace current word or visual selection and use . to repeat on next occurance(s) |

## Dependencies (need to be installed manually) 
- fzf (automatically installed)
- ripgrep (for multi-file search, and for fzf to work) 
- [bat](https://github.com/sharkdp/bat?tab=readme-ov-file#installation) (for colored previews, colorscheme downloaded automatically by dot setup, don't forget to run `bat cache --build`)
- lazygit as git gui
- delta as git pager (automatically installed)
- eza as ls replacement 
- zoxide as cd replacement 
- tldr as better man
- neofetch 
- starship for bash prompt 


## To-do 
- make readme look better
- git integration: fugitive, set up vim nvim parity with gitgutter and gitsigns 
- extract XDG config stuff as environment variables 
- figure out running how to bashrc system wide 
- add flag to setup to forcibly reinstall everything
- vim-floatterm form lazygit integration
- move inputrc and bash files outside of home directory
