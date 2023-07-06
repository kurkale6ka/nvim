au BufEnter *
    \ if &ft != 'help' && &ft != 'man' |
    \     silent! cd %:p:h |
    \ else |
    \     exe 'wincmd H | vert resize '.$MANWIDTH |
    \ endif

au BufReadPost * exe 'normal! g`"'

" Delete EOL white spaces
au BufWritePre *
    \ if &ft != 'markdown' |
    \     call spaces#remove() |
    \ endif
