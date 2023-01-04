" " TODO: separate function, to emulate vf()
" command! -nargs=+ VF call fzf#run(fzf#wrap({
"    \ 'source': 'locate -0 / | grep -zv "/\.\(git\|svn\|hg\)\(/\|$\)\|~$"',
"    \ 'options': '--read0 -0 -1 -m -q"'.<q-args>.'" --prompt "VF> "'
"    \ }))
" nmap <s-space> :VF<space>

" Keymaps
command! -nargs=? Lang call fzf#run(fzf#wrap({
   \ 'source': map(split(globpath(&rtp, 'keymap/*.vim')),
   \              'fnamemodify(v:val, ":t:r")'),
   \ 'sink': {keymap -> execute('setlocal keymap='.keymap)},
   \ 'options': '-1 +m -q "'.<q-args>.'" --prompt "Keymap> "'
   \ }))

" Scriptnames
command! -nargs=? Scriptnames call fzf#run(fzf#wrap({
   \ 'source': split(execute('scriptnames'), '\n'),
   \ 'sink': {script -> execute('edit'.substitute(script, '^\s*\d\+:\s\+', '', ''))},
   \ 'options': '-1 +m -q "'.<q-args>.'" --prompt "Scriptnames> "'
   \ }))
