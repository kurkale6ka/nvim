cd to the plugin dir
noplugins - enable vimball
:packadd vimball
:let g:vimball_home='/home/mitko/.local/share/nvim/lazy/ultisnips'
:0r !fd -tf --strip-cwd-prefix
:v#/#d # delete all files that aren't under any dir/
also delete unnecessary folders such as test/
vaf
:'<,'>MkVimball! UltiSnips
