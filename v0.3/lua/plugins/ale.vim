nmap <leader>f :ALEFix<cr>

let g:ale_linters = {'python': ['mypy', 'pyflakes', 'pyright']}

let g:ale_python_mypy_executable = $HOME.'/py-envs/neovim/bin/mypy'

let g:ale_fixers = {'python': ['black']}

let g:ale_python_black_executable = $HOME.'/py-envs/neovim/bin/black'
let g:ale_python_pyflakes_executable = $HOME.'/py-envs/neovim/bin/pyflakes'

" Diagnostic maps
" local opts = { silent = true }

" vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
" vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
" vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

" vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)

nmap <silent> gd :ALEGoToDefinition<cr>
nmap <silent> K :ALEHover<cr>
nmap <silent> <leader>i :ALEGoToImplementation<cr>

" vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

" vim.keymap.set('n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
" vim.keymap.set('n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
" vim.keymap.set('n', '<localleader>wl',
"     function()
"         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
"     end,
"     bufopts
" )

nmap <silent> <leader>D :ALEGoToTypeDefinition<cr>
nmap <silent> <leader>m :ALERename<cr>
nmap <silent> <leader>ca :ALECodeAction<cr>
nmap <silent> <leader>r :ALEFindReferences<cr>
nmap <silent> <leader>f :ALEFix<cr>
