if !has('gui_running') | set t_Co=256 | endif 

" set catppucin colorscheme
let g:lightline = { 
      \'colorscheme': 'catppuccin_mocha',
      \  'active': {
      \    'left': [['mode', 'paste'], ['readonly', 'filename', 'modified']],
      \    'right': [['lineinfo'], ['percent']]
      \  }
      \}
colorscheme catppuccin_mocha
set termguicolors
set noshowmode

" autocomplete options 
set complete+=kspell
set completeopt=menuone,longest
set shortmess+=c

" split below
set splitbelow

" Set relative linenumbers 
set relativenumber

" auto-resize splits when Vim gets resized 
autocmd VimResized * wincmd =
