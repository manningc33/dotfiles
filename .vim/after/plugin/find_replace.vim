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
  " save fzf history 
  let g:fzf_history_dir = '~/.vim/data/fzf-history'

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
          \  1, fzf#vim#with_preview({ 'options': query . ' --exact' }), 1)
  endfunction

  command! -nargs=* Find
        \ call FindInFile(<q-args>)

  " Ctrl-f find current word in current file w/ preview
  " Visual mode depends on visual-star-search plugin
  nnoremap <C-f> :silent! normal! *#<CR>:Find zy6qcgxYhJ<CR>
  xmap <C-f> *N:<C-u>Find "<C-r>=@/<CR>"<CR>
  nnoremap <Leader>f :Find<CR><C-p>
  xnoremap <Leader>f :<C-U>Find<CR><C-p> 

  " Allow passing optional flags into the Rg command.
  "   Example: :Rg myterm -g '*.md'
  command! -nargs=* Rg
        \ call fzf#vim#grep(
        \ "rg --column --line-number --no-heading --color=always --smart-case " .
        \ <q-args>, 1, fzf#vim#with_preview({ 'options': '--exact' }), 1)

  " \ used to search files, use Ctrl to search from home  
  nnoremap \ :Files<CR>
  nnoremap <C-\> :Files ~<CR>
  
  " leader b to search open buffers 
  " leader l to search lines in open buffers
  nnoremap <Leader>b :Buffers<CR>
  nnoremap <Leader>l :Lines<CR>
else 
  nnoremap <Leader>b :buffers<CR>:buffer<Space>
endif

