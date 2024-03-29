" ctrl-s to save 
nnoremap <C-s> :w<CR>

" tab navigation mapping
map <C-Down> <C-W>j
map <C-Up> <C-W>k
map <C-Left> <C-W>h
map <C-Right> <C-W>l

" scrolling up and down places cursor in middle of page
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
map <PageUp> <C-u> 
map <PageDown> <C-d>

" provide Tab and shift-Tab functionality 
" nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>

" ; to to fzf files 
if exists(':Files')
  nnoremap ; :Files<CR>
  nnoremap <C-p> :Files<CR>
endif

" NERDTree mappings
map <C-o> :NERDTreeToggle<CR>


