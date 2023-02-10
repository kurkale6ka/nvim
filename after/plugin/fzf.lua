-- git ls-files
vim.api.nvim_create_user_command('GFiles',
    function(input)
        vim.fn['fzf#vim#gitfiles'](
            input.args, -- git options
            { options = { '--cycle' } },
            input.bang -- fullscreen bool
        )
    end,
    { bang = true, nargs = '?', desc = 'git -h ls-files' }
)

vim.keymap.set('n', '<leader>l', ':GFiles<cr>')

vim.keymap.set('n', '<leader>sf', ':silent! Glcd <bar> Files<cr>') -- search fzf files
vim.keymap.set('n', '<leader>h', ':History<cr>')   -- search history (recently edited files)
vim.keymap.set('n', '<leader>sh', ':Helptags<cr>') -- search help files
vim.keymap.set('n', 'gh', ':Files '..vim.env.XDG_CONFIG_HOME..'/repos/help<cr>') -- own help files

vim.keymap.set('n', '<leader>sd', ':Diagnostics<cr>') -- search diagnostics
vim.keymap.set('n', '<leader>ss', ':Snippets<cr>')    -- search snippets
vim.keymap.set('n', '<leader>st', ':Tags<cr>')        -- search tags
vim.keymap.set('n', '<leader>sc', ':Commands<cr>')    -- search commands
vim.keymap.set('n', '<leader>sm', ':Maps<cr>')        -- search maps

vim.keymap.set('n', '<leader>t', ':Filetypes<cr>') -- set 'ft
vim.keymap.set('n', '<leader>b', ':Buffers<cr>')
vim.keymap.set('n', '<leader>/', ':BLines<cr>') -- fuzzy /
vim.keymap.set('n', '<leader>G', ':BLines <c-r><c-a>') -- fuzzy :g/
vim.keymap.set('n', '<leader>g', ':silent! Glcd <bar> exe "Rg ".input("ripgrep> ")<cr>') -- ripgrep

-- Rg: ripgrep
-- TODO: \bpyright regex not working
vim.api.nvim_create_user_command('Rg',
    function(input)
        vim.fn['fzf#vim#grep'](
            'rg --column --line-number --no-heading --color=always --smart-case --hidden -- ' .. vim.fn.shellescape(input.args),
            1, -- was --column passed?
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' }
            },
            input.bang -- fullscreen?
        )
    end,
    { bang = true, nargs = '*', desc = 'ripgrep' }
)

-- Diagnostics
vim.api.nvim_create_user_command('Diagnostics',
    function(input)
        vim.fn['fzf#run'](
            vim.fn['fzf#wrap'] {
                source = vim.tbl_map(
                    -- TODO: improve - serialize/deserialize table?
                    function(error)
                        return error.lnum + 1 .. ':' .. error.col + 1 .. ':' .. error.message
                    end,
                    vim.diagnostic.get(0)
                ),
                sink = function(error)
                    local position = vim.list_slice(vim.fn.split(error, ':'), 1, 2)
                    vim.fn.cursor(position)
                end,
                options = '--cycle -1 +m -q "' .. input.args .. '" --prompt "Diagnostics> "'
            }
        )
    end,
    { nargs = '?', desc = 'fuzzy diagnostics' }
)

-- Keymaps
vim.api.nvim_create_user_command('Lang',
    function(input)
        vim.fn['fzf#run'](
            vim.fn['fzf#wrap'] {
                source = vim.fn.map(vim.fn.split(vim.fn.globpath(vim.o.rtp, 'keymap/*.vim')), 'fnamemodify(v:val, ":t:r")'),
                sink = function(keymap)
                    vim.bo.keymap = keymap
                end,
                options = '--cycle -1 +m -q "' .. input.args .. '" --prompt "Keymap> "'
            }
        )
    end,
    { nargs = '?', desc = 'fuzzy keymap layouts' }
)

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
                options = '--cycle -1 +m -q "' .. input.args .. '" --prompt "Scriptnames> "'
            }
        )
    end,
    { nargs = '?', desc = 'fuzzy :scriptnames' }
)
