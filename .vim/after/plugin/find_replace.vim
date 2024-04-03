if exists('g:loaded_after_find_replace')
  finish
endif

let g:loaded_after_find_replace = 1

" replace previously highlighted search in file
" Can apply it to only a visual selection in visual mode
nnoremap <Leader>r :%s///g<Left><Left>
xnoremap <Leader>r :%s///g<Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> c* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> c* "sy:let @/=@s<CR>cgn

" fzf dependant finds
if exists(':Files')
  function FindInFile(token,...) 
    let query = ''
    if !empty(a:token) 
      if a:token == 'zy6qcgxYhJ'
        if !empty(expand('<cword>'))
          let query = '--query ' . expand('<cword>')
        endif
      else 
        let query = '--query ' . a:token
      endif
    endif

    call fzf#vim#grep( "rg --column --line-number --no-heading --color=always --smart-case '' /dev/null " . expand('%'), 
          \  1, fzf#vim#with_preview( { 'options': query . ' --exact' } ) )
  endfunction

  command! -bang -nargs=* Find
        \ call FindInFile(<q-args>)

  " Ctrl-f find current word in current file w/ preview
  " Visual mode depends on visual-star-search plugin
  nnoremap <C-f> :silent! normal! *#<CR>:Find zy6qcgxYhJ<CR>
  xmap <C-f> *N:<C-u>Find "<C-r>=@/<CR>"<CR>

  " Allow passing optional flags into the Rg command.
  "   Example: :Rg myterm -g '*.md'
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \ "rg --column --line-number --no-heading --color=always --smart-case " .
        \ <q-args>, 1, fzf#vim#with_preview({ 'options': '--exact' }), <bang>0)

  " leader f to search files in current dirs 
  " leader b to search open buffers 
  " leader l to search lines in open buffers
  nnoremap <Leader>f :Files<CR>
  nnoremap <Leader>b :Buffers<CR>
  nnoremap <Leader>l :Lines<CR>

  nnoremap <C-p> :Files<CR>
  nnoremap \ :Files<CR>
  " use Ctrl+\ to search from home
  nnoremap <C-\> :Files ~<CR>
else 
  nnoremap <Leader>b :buffers<CR>:buffer<Space>
endif

