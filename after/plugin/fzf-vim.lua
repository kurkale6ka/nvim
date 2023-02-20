-- Fuzzy files
vim.keymap.set('n', '<leader>b', ':Buffers<cr>')
vim.keymap.set('n', '<leader>h', ':History<cr>') -- recently edited files
vim.keymap.set('n', '<leader>l', ':GFiles<cr>') -- ls git files
vim.keymap.set('n', '<leader>sf', ':silent! Glcd <bar> Files<cr>') -- search fzf files
vim.keymap.set('n', '<leader>t', ':Filetypes<cr>')

-- Fuzzy help
vim.keymap.set('n', '<leader>sh', ':Helptags<cr>') -- search help files
vim.keymap.set('n', 'gh', ':Files ' .. vim.env.XDG_CONFIG_HOME .. '/repos/help<cr>') -- own help files

-- Fuzzy grep
vim.keymap.set('n', '<leader>/', ':BLines<cr>') -- /fuzzy
vim.keymap.set('n', '<leader>G', ':BLines <c-r><c-a>') -- :g/fuzzy
vim.keymap.set('n', '<leader>g', ':silent! Glcd <bar> exe "Rg ".input("ripgrep> ")<cr>') -- ripgrep

vim.keymap.set('n', '<leader>sc', ':Commands<cr>')
vim.keymap.set('n', '<leader>sd', ':Diagnostics<cr>') -- search LSP diagnostics
vim.keymap.set('n', '<leader>sm', ':Maps<cr>')
vim.keymap.set('n', '<leader>ss', ':Snippets<cr>')
vim.keymap.set('n', '<leader>st', ':Tags<cr>') -- search project tags

-- Buffers
vim.api.nvim_create_user_command('Buffers',
    function(input)
        vim.fn['fzf#vim#buffers'](
            input.args, -- buffer
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, complete = 'buffer', nargs = '?', desc = 'Show all buffers' }
)

-- History: recently edited files
vim.api.nvim_create_user_command('History',
    function(input)
        vim.fn['fzf#vim#history'](
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = 'Fuzzy history (recently edited files)' }
)

-- GFiles: git ls-files
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

-- Files: fzf files
vim.api.nvim_create_user_command('Files',
    function(input)
        vim.fn['fzf#vim#files'](
            input.args, -- directory
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, nargs = '?', complete = 'dir', desc = 'fzf files' }
)

-- Filetypes
vim.api.nvim_create_user_command('Filetypes',
    function(input)
        vim.fn['fzf#vim#filetypes'](
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, desc = 'Fuzzy filetypes' }
)

-- Helptags
vim.api.nvim_create_user_command('Helptags',
    function(input)
        vim.fn['fzf#vim#helptags'](
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, desc = 'Fuzzy help files search' }
)

-- BLines: /fuzzy search
vim.api.nvim_create_user_command('BLines',
    function(input)
        vim.fn['fzf#vim#buffer_lines'](
            input.args, -- fzf query
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = '/fuzzy search' }
)

-- Commands
vim.api.nvim_create_user_command('Commands',
    function(input)
        vim.fn['fzf#vim#commands'](
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, desc = 'Fuzzy commands' }
)

-- Rg: ripgrep
vim.api.nvim_create_user_command('Rg',
    function(input)
        vim.fn['fzf#vim#grep'](
            'rg --column --line-number --no-heading --color=always --smart-case --hidden -- ' .. vim.fn.shellescape(input.args),
            true, -- column option was passed
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' }
            },
            input.bang
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
    { nargs = '?', desc = 'Fuzzy diagnostics' }
)

-- Maps
vim.api.nvim_create_user_command('Maps',
    function(input)
        vim.fn['fzf#vim#maps'](
            input.args ~= '' and input.args or 'n', -- mode
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, nargs = '?', desc = 'Fuzzy mappings. :Maps mode ("n" default)' }
)

-- Snippets
vim.api.nvim_create_user_command('Snippets',
    function(input)
        vim.fn['fzf#vim#snippets'](
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, bar = true, desc = 'Fuzzy snippets' }
)

-- Tags
vim.api.nvim_create_user_command('Tags',
    function(input)
        vim.fn['fzf#vim#tags'](
            input.args, -- tag
            { options = { '--cycle' } },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = 'Fuzzy project (ctags -R) tags' }
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
    { nargs = '?', desc = 'Fuzzy keymap layouts' }
)

-- Scriptnames
vim.api.nvim_create_user_command('Scriptnames',
    function(input)
        vim.fn['fzf#run'](
            vim.fn['fzf#wrap'] {
                -- the script arg below will represent a line from source
                source = vim.fn.split(vim.fn.execute('scriptnames'), '\n'),
                sink = function(name)
                    vim.fn.execute('script' .. name)
                end,
                options = '--cycle -1 +m -q "' .. input.args .. '" --prompt "Scriptnames> "'
            }
        )
    end,
    { nargs = '?', desc = 'Fuzzy :scriptnames' }
)
