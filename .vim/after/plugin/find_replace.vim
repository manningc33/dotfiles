if exists('g:loaded_after_find_replace')
  finish
endif

let g:loaded_after_find_replace = 1

" replace previously highlighted search in file
" Can apply it to only a visual selection in visual mode
nnoremap <Leader>r :%s///g<Left><Left>
xnoremap <Leader>r :s///g<Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> c* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> c* "sy:let @/=@s<CR>cgn

" \ to fzf files 
" Navigating buffer, use fzf :Buffers if defined
if exists(':Files')
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

  " Find in current file w/ preview
  nmap <C-f> :silent! exe "normal *"<CR>:Find xxxxx<CR>

  " nnoremap <C-f> :Rg '' <c-r>=expand('%')<CR> ~/meowmeowmeowignore.urmom<CR> 

  function FindInFile(token,...) 
    let query = ''
    if !empty(a:token) 
      if a:token == 'xxxxx'
        try
          let query = '--query ' . expand('<cword>')
        endtry
      else 
        let query = '--query ' . a:token
      endif
    endif

    let grepCMD = "rg --column --line-number --no-heading --color=always --smart-case '' ~/meowmeowmeowignore.urmom " . expand('%')
    call fzf#vim#grep( grepCMD,
          \  1, fzf#vim#with_preview( { 'options': query . ' --bind ctrl-c:clear-query ' } ) )
  endfunction

  command! -bang -nargs=* Find
        \ call FindInFile(<q-args>)

  " Allow passing optional flags into the Rg command.
  "   Example: :Rg myterm -g '*.md'
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \ "rg --column --line-number --no-heading --color=always --smart-case " .
        \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)


else 
  nnoremap <Leader>b :buffers<CR>:buffer<Space>
endif
