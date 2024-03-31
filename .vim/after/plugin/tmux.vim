if exists('g:loaded_after_tmux')
  finish
endif 

let g:loaded_after_tmux = 1

" vim-tmux navigation mappings
if exists(':TmuxNavigateLeft')
  noremap <silent> <C-Left> :<C-U>TmuxNavigateLeft<cr>
  noremap <silent> <C-Down> :<C-U>TmuxNavigateDown<cr>
  noremap <silent> <C-Up> :<C-U>TmuxNavigateUp<cr>
  noremap <silent> <C-Right> :<C-U>TmuxNavigateRight<cr>
endif 

let g:tmux_resizer_no_mappings = 1

" set how much to resize windows
let g:tmux_resizer_resize_count = 4
let g:tmux_resizer_vertical_resize_count = 8

" vim-tmux resizing mappings
if exists(':TmuxResizeLeft')
  nnoremap <silent> <M-Left> :TmuxResizeLeft<CR>
  nnoremap <silent> <M-Down> :TmuxResizeDown<CR>
  nnoremap <silent> <M-Up> :TmuxResizeUp<CR>
  nnoremap <silent> <M-Right> :TmuxResizeRight<CR>
endif
