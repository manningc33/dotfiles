if !has('gui_running') | set t_Co=256 | endif 

let g:NERDTreeStatusLine = '%#NonText#'

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

" split below
set splitbelow

" Set relative linenumbers 
set relativenumber

" Show hidden files in NERDTree
let NERDTreeShowHidden = 1

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | 
  \ wincmd p | enew | execute 'cd '.argv()[0] | NERDTreeFocus | endif

" Close the tab if NERDTree is the only window remaining in it. 
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif 

" Open a copy of current NERDTree when opening a new tab
autocmd BufWinEnter * silent NERDTreeMirror
