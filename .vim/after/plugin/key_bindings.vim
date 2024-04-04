if exists('g:loaded_after_key_bindings.vim')
  finish
endif

let g:loaded_after_key_bindings = 1

" :W sudo saves the file (useful for handling the permission-denied error) 
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Clear highlighting on escrape in normal mode 
"nnoremap <esc><esc> :noh<return> 

nnoremap <Down> g<Down> 
"nnoremap <Up> gk 

" scrolling up and down places cursor in middle of page
nnoremap <C-u> <C-u>zzzv
nnoremap <C-d> <C-d>zzzv
map <PageUp> <C-u> 
map <PageDown> <C-d>

" Navigating to next find 
nnoremap n nzzzv
noremap N Nzzzv

" Search word stays at current place 
nnoremap # #N 
nnoremap * *N

" provide Tab and shift-Tab functionality 
inoremap <S-Tab> <C-d>
" nnoremap <Tab> >>
" nnoremap <S-Tab> <<

" Extended Home functionality 
function ExtendedHome()
  let column = col('.')
  normal! ^
  if column == col('.')
    normal! 0
  endif
endfunction

noremap <silent> <Home> :call ExtendedHome()<CR>
inoremap <silent> <Home> <C-O>:call ExtendedHome()<CR>
