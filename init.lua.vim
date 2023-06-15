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
nmap gr :later 9999<cr>
nmap <leader>- <c-^>
nmap <leader>a :A<cr>

" Search and replace
set incsearch
set hlsearch
set ignorecase
set smartcase
set infercase

set inccommand=nosplit
vim.opt.path:append(vim.env.REPOS_BASE .. '/**')
set grepprg='rg --column --line-number --no-heading --vimgrep --smart-case --hidden'

vim.keymap.set('n', '<leader>G', ':g/<c-r><c-a>/', { desc = ':g/WORD/' })
vim.keymap.set('n', '<leader>S', ':%s/<c-r><c-a>//g<left><left>', { desc = ':%s/WORD/|/g' })

" tilda is hard to type, :eh<space> -> :e~/
vim.cmd([[cabbrev <expr> eh getcmdtype() == ':' ? 'e~/'.abbreviations#eat_char('\s') : 'eh']])
vim.cmd([[cabbrev <expr> es getcmdtype() == ':' ? 'e%:p:s/'.abbreviations#eat_char('\s') : 'es']])

" Encoding and file formats
vim.opt.fileencodings:append('cp1251')
vim.opt.fileformats = { 'unix', 'mac', 'dos' }
vim.opt.isfname:remove('=')

" Alerts and visual feedback
vim.wo.number = true
vim.wo.numberwidth = 1
set showmatch
set matchtime=2
vim.opt.matchpairs:append('<:>')
set confirm
set showcmd
set report=0
set shortmess=flmnrxoOtT
vim.opt.display:append('truncate')
set lazyredraw
set scrolloff=2
set sidescroll=1
set sidescrolloff=1
set timeoutlen=2000 " 2s before timing out a mapping (twice the default, else I fail to complete some maps)
set ttimeoutlen=100 " 100 ms before timing out on a keypress (..^)
set visualbell " visual bell instead of beeps, but...
set linebreak " wrap at characters in 'breakat
vim.wo.breakindent = true " respect indentation when wrapping
set showbreak=↪
vim.opt.listchars = { precedes = '<', tab = '▷⋅', nbsp = '⋅', trail = '⋅', extends = '>' }
vim.wo.list = true
set synmaxcol=301

if not vim.wo.diff then
    vim.wo.cursorline = true " unless nvim -d was used, ref: https://github.com/neovim/neovim/issues/9800
end

vim.api.nvim_create_user_command('Ascii',
    'call ascii#codes(<f-args>)', {
    nargs = '*',
    desc = 'Print a range of ascii characters. Ex: Ascii 30 50',
})

" folding
vim.wo.foldnestmax = 1 " maximum nesting for indent and syntax
vim.cmd([[cabbrev <expr> fold getcmdtype() == ':' ? "se fdm=expr fde=getline(v\\:lnum)=~'^\\\\s*##'?'>'.(len(matchstr(getline(v\\:lnum),'###*'))-1)\\:'='".abbreviations#eat_char('\s') : 'fold']])
vim.cmd([[cabbrev foldx se fdm=expr fde=getline(v\:lnum)=~'<'?'>1'\:'='<left><left><left><left><left><left><left><left><left><left><left><c-r>=abbreviations#eat_char('\s')<cr>]])

vim.keymap.set('n', '<c-g>', '2<c-g>', { desc = 'print working directory' })
vim.keymap.set('n', '<leader>8', ':call highlight#column()<cr>', { silent = true, desc = 'highlight text beyond the 80th column' })

" Mouse support
set mouse=a
set mousemodel=extend
vim.keymap.set('n', '<S-ScrollWheelDown>', '5zl', { desc = 'Scroll right' })
vim.keymap.set('n', '<S-ScrollWheelUp>', '5zh', { desc = 'Scroll left' })

" Text formating
vim.opt.formatoptions:append('ron')
set comments=vim.o.comments:gsub('fb:%-', 'b:-') " lists with dashes. Note: - is a magic character in lua patterns => it needs to be escaped with %
set commentstring=#%s
set autoindent
set nojoinspaces

vim.keymap.set('n', 'Q', 'gqap', { desc = 'Format a paragraph with gq' })
vim.keymap.set('n', '<leader>z', ':call squeeze#lines("")<cr>', { silent = true, desc = 'squeeze lines' })
vim.keymap.set('n', '=<leader>', '[<leader>]<leader>', { remap = true, desc = 'surround with empty lines' })

" TODO: Ctrl + Enter to open a line below in INSERT mode
" imap <c-cr> <esc>o
" imap <s-cr> <esc>O

vim.api.nvim_create_user_command('Underline',
    'call underline#current(<q-args>)', " TODO: function() ... args?
    { nargs = '?', desc = 'Underline with dashes by default' }
)

" Tabs and shifting
set tabstop=8
set softtabstop=4
set expandtab
set smarttab
set shiftwidth=4
set shiftround

vim.keymap.set('x', '<tab>', '>', { desc = 'shift rightwards' })
vim.keymap.set('x', '<s-tab>', '<', { desc = 'shift leftwards' })
vim.keymap.set({ 'n', 'x' }, '<leader>0', ':left<cr>', { desc = 'align left' })

" Tags
vim.opt.tags:append(vim.env.REPOS_BASE .. '/tags')
vim.opt.complete:remove('i')
vim.opt.completeopt:append('menuone')
set showfulltag

" Windows and buffers
set hidden
vim.opt.diffopt:append { 'vertical', 'iblank', 'iwhiteall' }
set noequalalways
set nosplitright
set switchbuf=useopen,usetab

" TODO: correctly restore window sizes.
" execute "Plug '".s:vim."/plugged/win_full_screen', { 'on': 'WinFullScreen' }"
vim.keymap.set('n', 'Zi', '<c-w>|<c-w>_', { desc = 'Zoom In' })
vim.keymap.set('n', 'Zo', '<c-w>=', { desc = 'Zoom Out' })
vim.keymap.set('n', '<c-w><c-t>', ':vs term://zsh<cr>i', { desc = "Open terminal in current file's working directory" })

" Security
set exrc
set secure " :autocmd, shell and write commands not allowed in CWD .exrc
set modeline
set modelines=3

" Editing
vim.opt.nrformats:remove('octal')
set whichwrap=b,s,<,>,[,]
set virtualedit=block
set paragraphs=nil " no wrongly defined paragraphs for non nroff,groff filetypes

set nostartofline
vim.keymap.set('x', '}', [[mode() == '<c-v>' ? line("'}")-1.'G' : '}']], { expr = true, desc = 'let } select the current column only when in visual-block mode' })
vim.keymap.set('x', '{', [[mode() == '<c-v>' ? line("'{")+1.'G' : '{']], { expr = true, desc = 'let { select the current column only when in visual-block mode' })

vim.keymap.set('n', '[P', ':pu!<cr>', { desc = 'force paste above' })
vim.keymap.set('n', ']P', ':pu<cr>', { desc = 'force paste below' })
vim.keymap.set('x', '<leader>x', "<esc>'<dd'>[pjdd`<P==", { desc = 'swap first and last line in a visual area' })
vim.keymap.set('n', 'dl', ':call spaces#remove_eof()<cr>', { silent = true, desc = 'delete EOF empty lines' })

" backspace
set backspace=indent,eol,start
vim.keymap.set('n', '<bs>', '"_X', { desc = 'use backspace for deleting' })
vim.keymap.set('n', '<c-h>', '"_X', { desc = 'use backspace for deleting' })

" define a file text-object
vim.keymap.set('x', 'af', 'ggVoG', { desc = 'whole file text-object' })
vim.keymap.set('o', 'af', ':normal vaf<cr>', { desc = 'whole file text-object' })

vim.api.nvim_create_user_command('RemoveEOLSpaces',
    function()
        vim.fn['spaces#remove']()
    end,
    { desc = 'remove EOL spaces' }
)

" Let [[, ]] work even when { is not in the first column
vim.keymap.set('n', '[[', [[:call search('^\S\@=.*{\s*$', 'besW')<cr>]], { silent = true, desc = 'let [[ work even when { is not in the first column' })
vim.keymap.set('n', ']]', [[:call search('^\S\@=.*{\s*$',  'esW')<cr>]], { silent = true, desc = 'let ]] work even when { is not in the first column' })

vim.keymap.set('o', '[[',
    function()
        if vim.fn.search([[^\S\@=.*{\s*$]], 'besW') ~= 0 and vim.fn.setpos("''", vim.fn.getpos('.')) == 0
        then
            return "''"
        else
            return [[\<esc>]]
        end
    end,
    { expr = true, desc = 'let [[ work even when { is not in the first column' }
)

vim.keymap.set('o', ']]',
    function()
        if vim.fn.search([[^\S\@=.*{\s*$]], 'esW') ~= 0 and vim.fn.setpos("''", vim.fn.getpos('.')) == 0
        then
            return "''"
        else
            return [[\<esc>]]
        end
    end,
    { expr = true, desc = 'let ]] work even when { is not in the first column' }
)

" Spell check suggestions
vim.keymap.set('n', '<leader>1', '1z=', { desc = 'Replace with 1st spell suggestion' })
vim.keymap.set('n', '<leader>2', '2z=', { desc = 'Replace with 2nd spell suggestion' })

" Get ex command output in a buffer
vim.api.nvim_create_user_command('Scratch',
    function(input)
        vim.fn['scratch#buffer'](input.args)
    end,
    { nargs = '+', desc = 'Get ex command output in a buffer' }
)

vim.api.nvim_create_user_command('Quotes',
    function ()
        local line = vim.fn.getline('.')
        local str_bgn = ''
        local idx = line:find('[=:]') or 0
        if line:sub(idx, idx) == '=' then
            str_bgn = line:sub(1, idx) " from start to =
        end
        if idx == 0 or line:sub(idx, idx) == '=' then
            str_end = line:sub(idx + 1):gsub('([^%s,]+)%s*,?%s*', '"%1", ') " from = to end
            str_end = str_end:gsub('"', '("', 1):sub(1, -3) .. ')' " add "(", then remove final ", "
        else
            str_end = line:gsub('([^%s:]+)%s*(:?)%s*', '"%1"%2 ') " "key": "value"
            str_end = str_end:sub(1, -2) " remove final ' '
        end
        vim.fn.setline('.', str_bgn .. str_end)
    end,
    { desc = 'Quote words: coordinates = x y => coordinates = ("x", "y"); key: value => "key": "value"' }
)
vim.keymap.set('n', 'goq', ':Quotes<cr>', { desc = "Quote words: coordinates = x y => coordinates = ('x', 'y')" })

" Includes
require('noplugins')
require('abbreviations')
require('auto-commands')
require('auto-commands/comments')
require('auto-commands/html')
require('clipboard')
require('readline')
require('statusline')
require('plugins') " last so if a plugin errors, my config will still mostly work

" TODO: move above so we can set vars for plugins?
vim.opt.runtimepath:append(vim.fn.stdpath('config') .. '/lua/local')
pcall(require, 'local') " custom setup
