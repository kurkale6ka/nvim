vim.cmd([[
" To be improved
setlocal makeprg=perl\ -c\ %\ $*
setlocal errorformat=%m\ at\ %f\ line\ %l.

iabbrev len length

let b:surround_{char2nr('c')} = "RED.\r.RESET"
]])
