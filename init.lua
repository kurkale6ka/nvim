-- TODO:
-- :Rg buffer-ring: up to go to last
-- :Rg \bpyright
-- let g:ansible_attribute_highlight = "ab"
-- let g:vim_json_syntax_conceal = 0
-- set backup
-- nmap <expr> <leader>g ':vert Git -p ', redefine command?
-- compare with coc completion
-- ts text objects: test selections
-- after ciw confirm with enter from completion, . won't repeat
-- where are dictionaries?
-- se dg still no luck
-- Fuzzy search
--   - diagnostics: sd
--   - sh: history vs gh: helptags, swap?
--     <localleader>h for local help?
--   - sg: GFiles vs gl (git list)
--   - use in mappings: coc, =oc, old option changing combis
-- yank highlight autocmd
-- add alt-. in cmdline
-- tidy init.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.python3_host_prog = '~/py-envs/utils/bin/python'

vim.o.termguicolors = true
vim.cmd 'colorscheme desertEX'

-- Backups
vim.o.writebackup = true
vim.o.backupext = '~'
vim.o.backupskip = nil
vim.o.autowrite = false
vim.o.autowriteall = false
vim.o.autoread = false
vim.o.undofile = true
vim.o.history = 10000
vim.o.shada = "'1000"

vim.keymap.set('n', '<leader>e', ':e')
vim.keymap.set('n', '<leader>w', ':w<cr>')
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
vim.opt.path:append { vim.env.XDG_CONFIG_HOME .. '/repos/**' }
vim.o.grepprg = 'rg --column --line-number --no-heading --vimgrep --smart-case --hidden'

-- \G for global
-- \S for substitute
vim.keymap.set('n', '<leader>G', ':g/<c-r><c-a>/')
vim.keymap.set('n', '<leader>S', ':%s/<c-r><c-a>//g<left><left>')

-- Tilda is hard to type :eh<space> -> :e~/
vim.cmd([[cabbrev <expr> eh getcmdtype() == ':' ? 'e~/'.abbreviations#eat_char('\s') : 'eh']])
vim.cmd([[cabbrev <expr> es getcmdtype() == ':' ? 'e%:p:s/'.abbreviations#eat_char('\s') : 'es']])

-- Encoding and file formats
vim.o.fileencodings = 'ucs-bom,utf-8,default,cp1251,latin1'
vim.o.fileformats = 'unix,mac,dos'
vim.opt.isfname:remove { '=' }

-- Alerts and visual feedback
vim.wo.number = true
vim.wo.numberwidth = 1
vim.o.showmatch = true
vim.o.matchtime = 2
vim.opt.matchpairs:append { '<:>' }
vim.o.confirm = true
vim.o.showcmd = true
vim.o.report = 0
vim.o.shortmess = 'flmnrxoOtT'
vim.opt.display:append { 'lastline' }
vim.o.lazyredraw = true
vim.o.scrolloff = 2
vim.o.timeoutlen = 2000 -- 2s before timing out a mapping
vim.o.ttimeoutlen = 100 -- 100 ms before timing out on a keypress
vim.o.visualbell = true -- visual bell instead of beeps, but...
vim.o.linebreak = true -- wrap at characters in 'breakat
vim.wo.breakindent = true -- respect indentation when wrapping
vim.wo.showbreak = '↪ '
vim.opt.listchars = { tab = '▷⋅', trail = '⋅', nbsp = '⋅' }

-- TODO: only one + test at the wrong location => move to autocmd
if vim.bo.readonly or not vim.bo.modifiable then
    vim.wo.list = false
else
    vim.wo.list = true
end

if not vim.wo.diff then
    vim.wo.cursorline = true
end

vim.o.synmaxcol = 301

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

vim.keymap.set('n', 'Q', 'gqap')

-- Underline
vim.api.nvim_create_user_command('Underline',
    'call underline#current(<q-args>)',
    { nargs = '?', desc = 'Underline with dashes by default' }
)

vim.keymap.set('n', '<leader>z', ':call squeeze#lines("")<cr>', { silent = true, desc = 'squeeze lines' })
vim.keymap.set('n', '=<leader>', '[<leader>]<leader>', { remap = true, desc = 'surround with empty lines' })

-- TODO: Ctrl + Enter to open a line below in INSERT mode
-- imap <c-cr> <esc>o
-- imap <s-cr> <esc>O

-- Tabs and shifting
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true

vim.keymap.set('x', '<tab>', '>', { desc = 'shift rightwards' })
vim.keymap.set('x', '<s-tab>', '<', { desc = 'shift leftwards' })

vim.keymap.set({ 'n', 'x' }, '<leader>0', ':left<cr>', { desc = 'align left' })

-- Tags
vim.opt.tags:append { vim.env.XDG_CONFIG_HOME .. '/repos/tags' }
vim.opt.complete:remove { 't' }
vim.opt.completeopt:remove { 'preview' }
vim.o.showfulltag = true

-- Windows and buffers
vim.o.hidden = true
vim.opt.diffopt:append { 'vertical,iblank,iwhiteall' }
vim.o.equalalways = false
vim.o.splitright = true
vim.o.switchbuf = 'useopen,usetab'

-- Security
vim.o.exrc = true
vim.o.secure = true -- :autocmd, shell and write commands not allowed in CWD .exrc
vim.o.modeline = true
vim.o.modelines = 3

-- Editing
vim.o.clipboard = 'unnamed,unnamedplus'
vim.keymap.set('n', '[P', ':pu!<cr>', { desc = 'force paste above' })
vim.keymap.set('n', ']P', ':pu<cr>', { desc = 'force paste below' })

vim.keymap.set('x', '<cr>', "<esc>'<dd'>[pjdd`<P==", { desc = 'swap first and last line in a visual area' })

-- Backspace
vim.keymap.set('n', '<bs>', '"_X', { desc = 'use backspace for deleting' })
vim.o.backspace = 'indent,eol,start'

vim.keymap.set('n', 'dl', ':call spaces#remove_eof()<cr>', { silent = true, desc = 'delete EOF empty lines' })

-- Remove eol spaces
vim.api.nvim_create_user_command('RemoveEOLSpaces',
    ':call spaces#remove()', {}
)

vim.o.virtualedit = 'block'
vim.o.whichwrap = 'b,s,<,>,[,]'
vim.o.paragraphs = nil -- no wrongly defined paragraphs for non nroff,groff filetypes

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

-- Text-object: file
vim.keymap.set('x', 'af', 'ggVoG')
vim.keymap.set('o', 'af', ':normal vaf<cr>')

vim.o.startofline = false

vim.keymap.set('x', '}', [[mode() == '<c-v>' ? line("'}")-1.'G' : '}']], { expr = true, desc = 'let } select the current column only when in visual-block mode' })

vim.keymap.set('x', '{', [[mode() == '<c-v>' ? line("'{")+1.'G' : '{']], { expr = true, desc = 'let { select the current column only when in visual-block mode' })

-- Spell check
vim.keymap.set('n', '<leader>1', '1z=')
vim.keymap.set('n', '<leader>2', '2z=')

vim.opt.nrformats:remove { 'octal' }

-- Get ex command output in a buffer
vim.api.nvim_create_user_command('Scratch',
    function(input)
        vim.fn['scratch#buffer'](input.args)
    end,
    { nargs = '+', desc = 'Get ex command output in a buffer' }
)

-- Quote coma separated items
-- TODO: fix a, b, c case (extra comas) + port to lua
-- cmd = apt install vim ->
-- cmd = ('apt', 'install', 'vim')
vim.api.nvim_create_user_command('Quotes',
    ".py3do return line.split('=', 1)[0].rstrip() + ' = ' + str(line.split('=', 1)[1].lstrip().split()).translate(str.maketrans('[]','()')) if '=' in line else str(line.split()).translate(str.maketrans('[]','()'))",
    { desc = 'Create python tuple("item1", "item2") from coma separated items' }
)

-- sudo :write
vim.api.nvim_create_user_command('WriteSudo',
    'write !sudo tee % >/dev/null', {}
)

require('noplugins')
require('autocmds')
require('readline')
require('statusline')
require('plugins')
require('plugins/nvim-lspconfig')
require('plugins/nvim-cmp')
require('plugins/tree-sitter')
require('plugins/ultisnips')
require('plugins/fern')
require('plugins/sleuth')
require('plugins/firenvim')
pcall(require, 'local') -- custom setup
