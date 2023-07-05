nmap <leader>f :ALEFix<cr>

let g:ale_linters = {'python': ['mypy', 'pyflakes', 'pyright']}

let g:ale_python_mypy_executable = $HOME.'/py-envs/neovim/bin/mypy'

let g:ale_fixers = {'python': ['black']}

let g:ale_python_black_executable = $HOME.'/py-envs/neovim/bin/black'
let g:ale_python_pyflakes_executable = $HOME.'/py-envs/neovim/bin/pyflakes'
