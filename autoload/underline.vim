" Underline:
" --------- (or any combination of characters, ex: =-=-=-=-)
function! underline#current(chars)

    let chars = empty(a:chars) ? '-' : a:chars

    let nb_columns = virtcol('$') - 1
    let nb_chars = strlen(chars)

    let nb_insertions = floor(nb_columns / str2float(nb_chars))
    let remainder = nb_columns % nb_chars

    let saveFormatoptions = &formatoptions
    set formatoptions-=o

    execute "normal! o\<esc>"

    let &formatoptions = saveFormatoptions

    execute 'normal! ' . float2nr(nb_insertions) . 'i' . chars . "\<esc>"

    if !empty(remainder)
        execute 'normal! A' . strpart(chars, 0, remainder) . "\<esc>"
    endif

endfunction
