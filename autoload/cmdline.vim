" Ctrl + w
" Make it wipeout more, like in readline
function! cmdline#ctrl_w()
    let cmd_r = strpart(getcmdline(), getcmdpos() - 1)
    let cmd_l = split(strpart(getcmdline(), 0, getcmdpos() - 1))
    if len(cmd_l) > 1
        let cmd_l = remove(cmd_l, 0, -2)
        let cmd_left = join(cmd_l)
        call setcmdpos(len(cmd_left) + 2)
        return cmd_left . ' ' . cmd_r
    else
        call setcmdpos(1)
        return cmd_r
    endif
endfunction

" Alt + d
" Delete the word in front of the cursor
function! cmdline#alt_d()
    let cmd_l = strpart(getcmdline(), 0, getcmdpos() - 1)
    let cmd_r = strpart(getcmdline(), getcmdpos() - 1)
    let cmd_r = substitute(cmd_r, '^.\{-}\w\+', '', '')
    call setcmdpos(len(cmd_l) + 1)
    return cmd_l . cmd_r
endfunction
