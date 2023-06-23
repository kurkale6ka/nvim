noplugins - enable vimball

cd to the plugin dir
packadd vimball
let g:vimball_home='/home/mitko/.local/share/nvim/lazy/vim-snippets'
0r !fd -tf -H
dl
vaf
'<,'>MkVimball! vim-snippets

open the vimball file
UseVimball ~/.config/nvim/pack/plugins/start/vim-snippets
