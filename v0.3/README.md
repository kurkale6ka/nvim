# Create
`cd ~/.local/share/nvim/lazy/vim-snippets`

```vim
:packadd vimball
:let g:vimball_home='/home/mitko/.local/share/nvim/lazy/vim-snippets'
:0r !fd -tf -H
dl
vaf
:'<,'>MkVimball! vim-snippets
:q!
```

`mv vim-snippets.vmb ~/.config/nvim/v0.3/vimballs`

# Install
`mkdir ~/.config/nvim/pack/plugins/start/vim-snippets`

Open the vimball file
```vim
:packadd vimball
:UseVimball ~/.config/nvim/pack/plugins/start/vim-snippets
```
