vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.python3_host_prog = '~/py-envs/neovim/bin/python'
vim.o.termguicolors = true

-- Backups
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupext = '~'
vim.o.backupskip = nil
vim.o.autowrite = false
vim.o.autowriteall = false
vim.o.autoread = true
vim.o.undofile = true
vim.o.history = 10000
vim.opt.shada:prepend('!')

vim.keymap.set('n', '<leader>e', ':e', { desc = 'avoid typing colon :-)' })
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'save buffer' })
vim.keymap.set('n', 'gr', ':later 9999<cr>', { desc = 'redo all changes' })
vim.keymap.set('n', '<leader>-', '<c-^>', { desc = 'switch to the alternate file' })
vim.keymap.set('n', '<leader>a', ':A<cr>', { desc = 'switch to projectionist-alternate' })

-- Search and replace
vim.o.incsearch  = true
vim.o.hlsearch   = true
vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.infercase  = true

vim.o.inccommand = 'nosplit'
vim.opt.path:append(vim.env.XDG_CONFIG_HOME .. '/repos/**')
vim.o.grepprg = 'rg --column --line-number --no-heading --vimgrep --smart-case --hidden'

vim.keymap.set('n', '<leader>G', ':g/<c-r><c-a>/', { desc = ':g/WORD/' })
vim.keymap.set('n', '<leader>S', ':%s/<c-r><c-a>//g<left><left>', { desc = ':%s/WORD/|/g' })

-- tilda is hard to type, :eh<space> -> :e~/
vim.cmd([[cabbrev <expr> eh getcmdtype() == ':' ? 'e~/'.abbreviations#eat_char('\s') : 'eh']])
vim.cmd([[cabbrev <expr> es getcmdtype() == ':' ? 'e%:p:s/'.abbreviations#eat_char('\s') : 'es']])

-- Encoding and file formats
vim.opt.fileencodings:append('cp1251')
vim.opt.fileformats = { 'unix', 'mac', 'dos' }
vim.opt.isfname:remove('=')

-- Alerts and visual feedback
vim.wo.number = true
vim.wo.numberwidth = 1
vim.o.showmatch = true
vim.o.matchtime = 2
vim.opt.matchpairs:append('<:>')
vim.o.confirm = true
vim.o.showcmd = true
vim.o.report = 0
vim.o.shortmess = 'flmnrxoOtT'
vim.opt.display:append('truncate')
vim.o.lazyredraw = true
vim.o.scrolloff = 2
vim.o.sidescroll = 1
vim.o.sidescrolloff = 1
vim.o.visualbell = true -- visual bell instead of beeps, but...
vim.o.linebreak = true -- wrap at characters in 'breakat
vim.wo.breakindent = true -- respect indentation when wrapping
vim.o.showbreak = '↪ '
vim.opt.listchars = { precedes = '<', tab = '▷⋅', nbsp = '⋅', trail = '⋅', extends = '>' }
vim.wo.list = true
vim.o.synmaxcol = 301

if not vim.wo.diff then
    vim.wo.cursorline = true -- unless nvim -d was used, ref: https://github.com/neovim/neovim/issues/9800
end

vim.api.nvim_create_user_command('Ascii',
    'call ascii#codes(<f-args>)', {
    nargs = '*',
    desc = 'Print a range of ascii characters. Ex: Ascii 30 50',
})

-- folding
vim.wo.foldnestmax = 1 -- maximum nesting for indent and syntax
vim.cmd([[cabbrev <expr> fold getcmdtype() == ':' ? "se fdm=expr fde=getline(v\\:lnum)=~'^\\\\s*##'?'>'.(len(matchstr(getline(v\\:lnum),'###*'))-1)\\:'='".abbreviations#eat_char('\s') : 'fold']])
vim.cmd([[cabbrev foldx se fdm=expr fde=getline(v\:lnum)=~'<'?'>1'\:'='<left><left><left><left><left><left><left><left><left><left><left><c-r>=abbreviations#eat_char('\s')<cr>]])

vim.keymap.set('n', '<c-g>', '2<c-g>', { desc = 'print working directory' })
vim.keymap.set('n', '<leader>8', ':call highlight#column()<cr>', { silent = true, desc = 'highlight text beyond the 80th column' })

-- Mouse support
vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'

-- Text formating
vim.opt.formatoptions:append('ron')
vim.o.comments = vim.o.comments:gsub('fb:%-', 'b:-') -- lists with dashes
vim.o.commentstring = '#%s'
vim.o.autoindent = true
vim.o.joinspaces = false

vim.keymap.set('n', 'Q', 'gqap', { desc = 'Format a paragraph with gq' })
vim.keymap.set('n', '<leader>z', ':call squeeze#lines("")<cr>', { silent = true, desc = 'squeeze lines' })
vim.keymap.set('n', '=<leader>', '[<leader>]<leader>', { remap = true, desc = 'surround with empty lines' })

-- TODO: Ctrl + Enter to open a line below in INSERT mode
-- imap <c-cr> <esc>o
-- imap <s-cr> <esc>O

vim.api.nvim_create_user_command('Underline',
    'call underline#current(<q-args>)', -- TODO: function() ... args?
    { nargs = '?', desc = 'Underline with dashes by default' }
)

-- Tabs and shifting
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true

vim.keymap.set('x', '<tab>', '>', { desc = 'shift rightwards' })
vim.keymap.set('x', '<s-tab>', '<', { desc = 'shift leftwards' })
vim.keymap.set({ 'n', 'x' }, '<leader>0', ':left<cr>', { desc = 'align left' })

-- Tags
vim.opt.tags:append(vim.env.XDG_CONFIG_HOME .. '/repos/tags')
vim.opt.complete:remove('i')
vim.opt.completeopt:append('menuone')
vim.o.showfulltag = true

-- Windows and buffers
vim.o.hidden = true
vim.opt.diffopt:append { 'vertical', 'iblank', 'iwhiteall' }
vim.o.equalalways = false
vim.o.splitright = false
vim.o.switchbuf = 'useopen,usetab'

-- TODO: correctly restore window sizes.
-- execute "Plug '".s:vim."/plugged/win_full_screen', { 'on': 'WinFullScreen' }"
vim.keymap.set('n', 'Zi', '<c-w>|<c-w>_', { desc = 'Zoom In' })
vim.keymap.set('n', 'Zo', '<c-w>=', { desc = 'Zoom Out' })
vim.keymap.set('n', '<c-w><c-t>', ':vs term://zsh<cr>i', { desc = "Open terminal in current file's working directory" })

-- Security
vim.o.exrc = true
vim.o.secure = true -- :autocmd, shell and write commands not allowed in CWD .exrc
vim.o.modeline = true
vim.o.modelines = 3

-- Editing
vim.o.clipboard = 'unnamed,unnamedplus'
vim.opt.nrformats:remove('octal')
vim.o.whichwrap = 'b,s,<,>,[,]'
vim.o.virtualedit = 'block'
vim.o.paragraphs = nil -- no wrongly defined paragraphs for non nroff,groff filetypes

vim.o.startofline = false
vim.keymap.set('x', '}', [[mode() == '<c-v>' ? line("'}")-1.'G' : '}']], { expr = true, desc = 'let } select the current column only when in visual-block mode' })
vim.keymap.set('x', '{', [[mode() == '<c-v>' ? line("'{")+1.'G' : '{']], { expr = true, desc = 'let { select the current column only when in visual-block mode' })

vim.keymap.set('n', '[P', ':pu!<cr>', { desc = 'force paste above' })
vim.keymap.set('n', ']P', ':pu<cr>', { desc = 'force paste below' })
vim.keymap.set('x', '<leader>x', "<esc>'<dd'>[pjdd`<P==", { desc = 'swap first and last line in a visual area' })
vim.keymap.set('n', 'dl', ':call spaces#remove_eof()<cr>', { silent = true, desc = 'delete EOF empty lines' })

-- backspace
vim.o.backspace = 'indent,eol,start'
vim.keymap.set('n', '<bs>', '"_X', { desc = 'use backspace for deleting' })
vim.keymap.set('n', '<c-h>', '"_X', { desc = 'use backspace for deleting' })

-- define a file text-object
vim.keymap.set('x', 'af', 'ggVoG', { desc = 'whole file text-object' })
vim.keymap.set('o', 'af', ':normal vaf<cr>', { desc = 'whole file text-object' })

vim.api.nvim_create_user_command('RemoveEOLSpaces',
    function()
        vim.fn['spaces#remove']()
    end,
    { desc = 'remove EOL spaces' }
)

-- Let [[, ]] work even when { is not in the first column
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

-- Spell check suggestions
vim.keymap.set('n', '<leader>1', '1z=', { desc = 'Replace with 1st spell suggestion' })
vim.keymap.set('n', '<leader>2', '2z=', { desc = 'Replace with 2nd spell suggestion' })

-- Get ex command output in a buffer
vim.api.nvim_create_user_command('Scratch',
    function(input)
        vim.fn['scratch#buffer'](input.args)
    end,
    { nargs = '+', desc = 'Get ex command output in a buffer' }
)

vim.api.nvim_create_user_command('Quotes',
    function ()
        local line = vim.fn.getline('.')
        -- TODO: json "key": "value"
        local eq_idx = (line:find('=') or 0) + 1
        local str_bgn = line:sub(1, eq_idx - 1) -- from start to '='
        local str_end = line:sub(eq_idx):gsub("([^%s,]+),?%s*", "'%1', ") -- from '=' to end
        str_end = str_end:gsub("'", "('", 1):sub(1, -3) .. ')' -- add "(", then remove final ", "
        vim.fn.setline('.', str_bgn .. str_end)
    end,
    { desc = "Quote words: coordinates = x y => coordinates = ('x', 'y')" }
)
vim.keymap.set('n', 'goq', ':Quotes<cr>', { desc = "Quote words: coordinates = x y => coordinates = ('x', 'y')" })

-- TODO:
-- use in mappings + find all free mappings:
--     goX, coc, =oc (old option changing combis), db ...
-- install dictionaries?
-- add alt-. in cmdline and c-y to paste
-- ls! unlisted help buffers, include in <leader>b?
-- redefine command G with :vert Git -p
-- jinja2 syntax? TS inject in ansible buffers?
-- TS text objects: test selections
-- TS info
-- gK for help, test it still works with 'wrap
-- after ciw confirm with enter from completion, '.' won't repeat
-- se dg still no luck: problem with both nvim cmp and lualine plugins
-- Session.vim went into wrong folder
-- duplicate symbols in cmdline, e.g. :h''spr => raise issue
-- fzf install issues (lazy.nvim) !!!
-- zsh snippets ft wrong because # defines a zsh shebang

require('noplugins')
require('abbreviations')
require('auto-commands')
require('auto-commands/comments')
require('auto-commands/html')
require('readline')
require('statusline')
require('plugins') -- last so if a plugin errors, my config will still mostly work

-- TODO: move above so we can set vars for plugins?
vim.opt.runtimepath:append(vim.fn.stdpath('config') .. '/lua/local')
pcall(require, 'local') -- custom setup
