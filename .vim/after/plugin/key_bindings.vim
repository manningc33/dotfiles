" :W sudo saves the file (useful for handling the permission-denied error) 
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Clear highlighting on escrape in normal mode 
nnoremap <esc><esc> :noh<return><esc>

" Navigating buffers
nnoremap <Leader>b :buffers<CR>:buffer<Space>

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
  nnoremap <C-p> :Files<CR>
  nnoremap \ :Files<CR>
  " use Ctrl+\ to search entire file system
  nnoremap <C-\> :Files /<CR>
endif

" NERDTree mappings
map <C-o> :NERDTreeToggle<CR>


