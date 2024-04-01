" :W sudo saves the file (useful for handling the permission-denied error) 
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Clear highlighting on escrape in normal mode 
nnoremap <esc><esc> :noh<return><esc>

" scrolling up and down places cursor in middle of page
nnoremap <C-u> <C-u>zzzv
nnoremap <C-d> <C-d>zzzv
map <PageUp> <C-u> 
map <PageDown> <C-d>

" provide Tab and shift-Tab functionality 
inoremap <S-Tab> <C-d>
" nnoremap <Tab> >>
" nnoremap <S-Tab> <<

" \ to fzf files 
" Navigating buffer, use fzf :Buffers if defined
if exists(':Files')
  nnoremap <C-p> :Files<CR>
  nnoremap \ :Files<CR>
  nnoremap <Leader>f :Files<CR>
  " use Ctrl+\ to search from home
  nnoremap <C-\> :Files ~<CR>
  nnoremap <Leader>b :Buffers<CR>
else 
  nnoremap <Leader>b :buffers<CR>:buffer<Space>
endif
