set nocompatible
let g:mapleader=","

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" symlink vim-plug location for nvim 
if has('nvim') && empty(glob('/site/autoload/plug.vim'))
  silent !sudo mkdir -p /site
  silent !rm -r /site/autoload 
  silent !sudo ln -nfs ~/.vim/autoload/ /site/autoload/
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif

call plug#begin()

if !has('nvim') && !exists('g:gui_oni') | Plug 'tpope/vim-sensible' | endif 
Plug 'rstacruz/vim-opinion'
Plug '~/.local/share/fzf' " fzf already installed by setup.sh
Plug 'junegunn/fzf.vim'
"Plug 'tpope/vim-sleuth'
"Plug 'sheerun/vim-polyglot'
"Plug 'dense-analysis/ale'
Plug 'lambdalisue/fern.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'vim-scripts/AutoComplPop'
Plug 'nelstrom/vim-visual-star-search'

call plug#end()

