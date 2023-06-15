" Use if nvim doesn't support loading from init.lua!

let mapleader = "\<space>"
let maplocalleader = '\\'
let g:python3_host_prog = '~/py-envs/neovim/bin/python'
set termguicolors

" Backups
set backup
set writebackup
set backupext=~
set backupskip=
set noautowrite
set noautowriteall
set autoread
set undofile
set history=10000
set shada^=!

nmap <leader>e :e
nmap <leader>w :w<cr>
nnoremap gr :later 9999<cr>
nnoremap <leader>- <c-^>
nmap <leader>a :A<cr>

" Search and replace
set incsearch
set hlsearch
set ignorecase
set smartcase
set infercase

set inccommand=nosplit
exe 'set path+='.$REPOS_BASE.'/**'
set grepprg=rg\ --column\ --line-number\ --no-heading\ --vimgrep\ --smart-case\ --hidden

nmap <leader>G :g/<c-r><c-a>/
nmap <leader>S :%s/<c-r><c-a>//g<left><left>

" tilda is hard to type, :eh<space> -> :e~/
cabbrev <expr> eh getcmdtype() == ':' ? 'e~/'.abbreviations#eat_char('\s') : 'eh'
cabbrev <expr> es getcmdtype() == ':' ? 'e%:p:s/'.abbreviations#eat_char('\s') : 'es'

" Encoding and file formats
set fileencodings+=cp1251
set fileformats=unix,mac,dos
set isfname-==

" Alerts and visual feedback
set number
set numberwidth=1
set showmatch
set matchtime=2
set matchpairs+=<:>
set confirm
set showcmd
set report=0
set shortmess=flmnrxoOtT
set display+=truncate
set lazyredraw
set scrolloff=2
set sidescroll=1
set sidescrolloff=1
set timeoutlen=2000 " 2s before timing out a mapping (twice the default, else I fail to complete some maps)
set ttimeoutlen=100 " 100 ms before timing out on a keypress (..^)
set visualbell " visual bell instead of beeps, but...
set linebreak " wrap at characters in 'breakat
set breakindent " respect indentation when wrapping
set showbreak=↪
set listchars=precedes:<,tab:▷⋅,nbsp:⋅,trail:⋅,extends:>
set list
set synmaxcol=301

if !&diff
   set cursorline " unless nvim -d was used, ref: https://github.com/neovim/neovim/issues/9800
endif

command! -nargs=* Ascii call ascii#codes(<f-args>)

" folding
set foldnestmax=1 " maximum nesting for indent and syntax
cabbrev <expr> fold getcmdtype() == ':' ? "se fdm=expr fde=getline(v\\:lnum)=~'^\\\\s*##'?'>'.(len(matchstr(getline(v\\:lnum),'###*'))-1)\\:'='".abbreviations#eat_char('\s') : 'fold'
cabbrev foldx se fdm=expr fde=getline(v\:lnum)=~'<'?'>1'\:'='<left><left><left><left><left><left><left><left><left><left><left><c-r>=abbreviations#eat_char('\s')<cr>

nnoremap <silent> <c-l> :nohlsearch<bar>diffupdate<bar>normal!<c-l><cr>
nnoremap <c-g> 2<c-g>
nmap <silent> <leader>8 :call highlight#column()<cr>

" Mouse support
set mouse=a
set mousemodel=extend
nmap <S-ScrollWheelDown> 5zl
nmap <S-ScrollWheelUp> 5zh

" Text formating
set formatoptions+=ron
exe 'let &comments = substitute(&comments, "f\\zeb:-", "", "")'
set commentstring=#%s
set autoindent
set nojoinspaces

nmap Q gqap
nmap <silent> <leader>z :call squeeze#lines("")<cr>
nmap =<leader> [<leader>]<leader>

" TODO: Ctrl + Enter to open a line below in INSERT mode
" imap <c-cr> <esc>o
" imap <s-cr> <esc>O

command! -nargs=? Underline call underline#current(<q-args>)

" Tabs and shifting
set tabstop=8
set softtabstop=4
set expandtab
set smarttab
set shiftwidth=4
set shiftround

xmap   <tab> >
xmap <s-tab> <
nmap <leader>0 :left<cr>
xmap <leader>0 :left<cr>

" Tags
exe 'set tags+='.$REPOS_BASE.'/tags'
set complete-=i
set completeopt+=menuone
set showfulltag

" Windows and buffers
set hidden
set diffopt+=vertical,iblank,iwhiteall
set noequalalways
set nosplitright
set switchbuf=useopen,usetab

" TODO: correctly restore window sizes.
" execute "Plug '".s:vim."/plugged/win_full_screen', { 'on': 'WinFullScreen' }"
nmap Zi <c-w><bar><c-w>_
nmap Zo <c-w>=
nmap <c-w><c-t> :vs term://zsh<cr>i

" Security
set exrc
set secure " :autocmd, shell and write commands not allowed in CWD .exrc
set modeline
set modelines=3

" Editing
set nrformats-=octal
set whichwrap=b,s,<,>,[,]
set virtualedit=block
set paragraphs= " no wrongly defined paragraphs for non nroff,groff filetypes

set nostartofline
xnoremap <expr> } mode() == '<c-v>' ? line("'}") - 1 . 'G' : '}'
xnoremap <expr> { mode() == '<c-v>' ? line("'{") + 1 . 'G' : '{'

nmap [P :pu!<cr>
nmap ]P :pu<cr>
xmap <leader>x <esc>'<dd'>[pjdd`<P==
nmap <silent> dl :call spaces#remove_eof()<cr>

" backspace
set backspace=indent,eol,start
nnoremap <bs> "_X
nnoremap <c-h> "_X

" define a file text-object
xnoremap af ggVoG
onoremap af :normal vaf<cr>

command! RemoveSpaces call spaces#remove()

" Let [[, ]] work even when { is not in the first column
nnoremap <silent> [[ :call search('^\S\@=.*{\s*$', 'besW')<cr>
nnoremap <silent> ]] :call search('^\S\@=.*{\s*$',  'esW')<cr>

onoremap <expr> [[
   \ (search('^\S\@=.*{\s*$', 'besW') &&
   \ (setpos("''", getpos('.')) <bar><bar> 1) ? "''" : "\<esc>")

onoremap <expr> ]]
   \ (search('^\S\@=.*{\s*$', 'esW') &&
   \ (setpos("''", getpos('.')) <bar><bar> 1) ? "''" : "\<esc>")

" Spell check suggestions
nmap <leader>1 1z=
nmap <leader>2 2z=

" Get ex command output in a buffer
command! -nargs=+ Scratch call scratch#buffer(<f-args>)

command! Quotes .py3do return line.split('=', 1)[0].rstrip() + ' = ' + str(line.split('=', 1)[1].lstrip().split()).translate(str.maketrans('[]','()')) if '=' in line else str(line.split()).translate(str.maketrans('[]','()'))
nmap goq :Quotes<cr>

" Includes
" source lua/noplugins.vim
" source lua/abbreviations.vim
" source lua/auto-commands.vim
" source lua/auto-commands/comments.vim
" source lua/auto-commands/html.vim
" source lua/clipboard.vim
" source lua/readline.vim
exe 'source '.stdpath('config').'/lua/statusline.vim'

colorscheme onedark

" TODO: move above so we can set vars for plugins?
" custom setup
exe 'set runtimepath+='.stdpath('config').'/lua/local'

if filereadable(stdpath('config').'/lua/local/init.vim')
   exe 'source '.stdpath('config').'/lua/local/init.vim'
endif
