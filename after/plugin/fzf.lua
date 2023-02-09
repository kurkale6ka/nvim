vim.keymap.set('n', '<leader>l', ':GFiles<cr>')    -- ls git files
vim.keymap.set('n', '<leader>sf', ':silent! Glcd <bar> Files<cr>') -- search fzf files
vim.keymap.set('n', '<leader>h', ':History<cr>')   -- search history (recently edited files)
vim.keymap.set('n', '<leader>sh', ':Helptags<cr>') -- search help files
vim.keymap.set('n', 'gh', ':Files '..vim.env.XDG_CONFIG_HOME..'/repos/help<cr>') -- own help files
vim.keymap.set('n', '<leader>ss', ':Snippets<cr>') -- search snippets
vim.keymap.set('n', '<leader>st', ':Tags<cr>')     -- search tags
vim.keymap.set('n', '<leader>sc', ':Commands<cr>') -- search commands
vim.keymap.set('n', '<leader>sm', ':Maps<cr>')     -- search maps
vim.keymap.set('n', '<leader>t', ':Filetypes<cr>') -- set 'ft
vim.keymap.set('n', '<leader>b', ':Buffers<cr>')
vim.keymap.set('n', '<leader>/', ':BLines<cr>') -- fuzzy /
vim.keymap.set('n', '<leader>G', ':BLines <c-r><c-a>') -- fuzzy :g/
vim.keymap.set('n', '<leader>g', ':silent! Glcd <bar> exe "Rg ".input("ripgrep> ")<cr>') -- ripgrep

-- Rg: ripgrep
-- TODO:
-- fzf buffer-ring: up to go to last item
-- \bpyright regex not working
vim.api.nvim_create_user_command('Rg',
    function(input)
        vim.fn['fzf#vim#grep'](
            'rg --column --line-number --no-heading --color=always --smart-case --hidden -- ' .. vim.fn.shellescape(input.args),
            1, -- was --column passed?
            vim.fn['fzf#vim#with_preview'](),
            input.bang -- fullscreen?
        )
    end,
    { bang = true, nargs = '*', desc = 'ripgrep' }
)

-- TODO: translate to lua
vim.cmd([[
" Keymaps
command! -nargs=? Lang call fzf#run(fzf#wrap({
   \ 'source': map(split(globpath(&rtp, 'keymap/*.vim')),
   \              'fnamemodify(v:val, ":t:r")'),
   \ 'sink': {keymap -> execute('setlocal keymap='.keymap)},
   \ 'options': '-1 +m -q "'.<q-args>.'" --prompt "Keymap> "'
   \ }))
]])

-- Scriptnames
vim.api.nvim_create_user_command('Scriptnames',
    function(input)
        vim.fn['fzf#run'](
            vim.fn['fzf#wrap'] {
                -- the script arg below will represent a line from source
                source = vim.fn.split(vim.fn.execute('scriptnames'), '\n'),
                sink = function(script)
                    vim.fn.execute('edit' .. vim.fn.substitute(script, [[^\s*\d\+:\s\+]], '', ''))
                end,
                options = '-1 +m -q "' .. input.args .. '" --prompt "Scriptnames> "'
            }
        )
    end,
    { nargs = '?', desc = 'fuzzy :scriptnames' }
)
