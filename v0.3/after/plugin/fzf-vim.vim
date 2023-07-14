" Fuzzy files
nmap <leader>b :Buffers<cr>
nmap <leader>h :History<cr>
nmap <leader>l :GFiles<cr>
nmap gol :GFiles?<cr>
nmap gof :silent! Glcd <bar> Files<cr>
nmap got :Filetypes<cr>

" Fuzzy help
nmap goh :Helptags<cr>
nmap <expr> gh ':Files '.$REPOS_BASE.'/github/help<cr>'

" Fuzzy grep
nmap <leader>/ :BLines<cr>
nmap <leader>G :BLines <c-r><c-a>
nmap <leader>g :silent! Glcd <bar> exe "Ag ".input("ripgrep> ")<cr>

nmap goc :Commands<cr>
nmap god :Diagnostics<cr>
nmap gom :Maps<cr>
nmap gos :Snippets<cr>
nmap <leader>t :BTags<cr>

command! -bang -nargs=* Ag
    \ call fzf#vim#grep(
    \   'ag --column --color --color-line-number="00;32" --color-path="00;35" --color-match="01;31" --smart-case --hidden -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)
