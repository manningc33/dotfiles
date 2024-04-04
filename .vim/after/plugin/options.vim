if !has('gui_running') | set t_Co=256 | endif 

" allow undos after save 
set undodir=~/.vim/data/undo
set undofile

" create undo folder if doesn't exist 
if !isdirectory($HOME .  '/.vim/data/undo')
  call mkdir($HOME . '/.vim/data/undo', 'p', 0700)
endif 

" set catppuccin colorscheme
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
set splitright

" Set relative linenumbers 
set relativenumber

" auto-resize splits when Vim gets resized 
autocmd VimResized * wincmd =

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
