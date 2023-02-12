lmapclear <buffer>

source $VIMRUNTIME/keymap/accents.vim

setlocal spelllang=fr
let b:keymap_name = "fr"

lnoremap <buffer> :e ë
lnoremap <buffer> :E Ë
lnoremap <buffer> :i ï
lnoremap <buffer> :I Ï
lnoremap <buffer> :y ÿ
lnoremap <buffer> :Y Ÿ
