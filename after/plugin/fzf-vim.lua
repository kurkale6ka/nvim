-- Original definitions at:
-- ~/.local/share/nvim/lazy/fzf.vim/plugin/fzf.vim

-- Fuzzy files
vim.keymap.set('n', '<leader>b', ':Buffers<cr>')
vim.keymap.set('n', '<leader>h', ':History<cr>') -- recently edited files
vim.keymap.set('n', '<leader>l', ':GFiles<cr>') -- ls git files
vim.keymap.set('n', 'gol', ':GFiles?<cr>') -- git status
vim.keymap.set('n', 'gof', ':silent! Glcd <bar> Files<cr>') -- search fzf files
vim.keymap.set('n', 'got', ':Filetypes<cr>')

-- Fuzzy help
vim.keymap.set('n', 'goh', ':Helptags<cr>') -- search help files
vim.keymap.set('n', 'gh', ':Files ' .. vim.env.XDG_CONFIG_HOME .. '/repos/github/help<cr>') -- own help files

-- Fuzzy grep
vim.keymap.set('n', '<leader>/', ':BLines<cr>') -- /fuzzy
vim.keymap.set('n', '<leader>G', ':BLines <c-r><c-a>') -- :g/fuzzy
vim.keymap.set('n', '<leader>g', ':silent! Glcd <bar> exe "Rg ".input("ripgrep> ")<cr>') -- ripgrep

vim.keymap.set('n', 'goc', ':Commands<cr>')
vim.keymap.set('n', 'god', ':Diagnostics<cr>') -- search LSP diagnostics
vim.keymap.set('n', 'gom', ':Maps<cr>')
vim.keymap.set('n', 'gos', ':Snippets<cr>')
vim.keymap.set('n', '<leader>t', ':BTags<cr>') -- search buffer tags

-- Buffers
vim.api.nvim_create_user_command('Buffers',
    function(input)
        vim.fn['fzf#vim#buffers'](
            input.args, -- buffer
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' },
                placeholder = '{1}',
            },
            input.bang -- fullscreen bool
        )
    end,
    { bang = true, bar = true, complete = 'buffer', nargs = '?', desc = 'Show all buffers' }
)

-- History: recently edited files
vim.api.nvim_create_user_command('History',
    function(input)
        vim.fn['fzf#vim#history'](
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' }
            },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = 'Fuzzy history (recently edited files)' }
)

-- GFiles: git ls-files
vim.api.nvim_create_user_command('GFiles',
    function(input)
        if input.args ~= '?' then
            vim.fn['fzf#vim#gitfiles'](
                input.args, -- git options
                vim.fn['fzf#vim#with_preview'] {
                    options = { '--cycle' }
                },
                input.bang
            )
        else
            -- GFiles?
            vim.fn['fzf#vim#gitfiles'](
                input.args, -- git options
                vim.fn['fzf#vim#with_preview'] {
                    options = { '--cycle' },
                    placeholder = ""
                },
                input.bang
            )
        end
    end,
    { bang = true, nargs = '?', desc = 'git -h ls-files' }
)

-- Files: fzf files
vim.api.nvim_create_user_command('Files',
    function(input)
        vim.fn['fzf#vim#files'](
            input.args, -- directory
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' }
            },
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
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' },
                placeholder = '--tag {2}:{3}:{4}',
            },
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
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' },
                placeholder = '--tag {2}:{-1}:{3..}',
            },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = 'Fuzzy project (ctags -R) tags' }
)

-- Btags
vim.api.nvim_create_user_command('Btags',
    function(input)
        vim.fn['fzf#vim#buffer_tags'](
            input.args, -- tag
            vim.fn['fzf#vim#with_preview'] {
                options = { '--cycle' },
                placeholder = '{2}:{3..}',
            },
            input.bang
        )
    end,
    { bang = true, nargs = '*', desc = 'Fuzzy tags in the current buffer' }
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
                source = vim.fn.split(vim.fn.execute('scriptnames'), '\n'),
                sink = function(name) -- represents a line from source
                    vim.fn.execute('script ' .. vim.trim(vim.split(name, ':', { plain = true })[1]))
                end,
                options = '--cycle --preview "bat {2}" -1 +m -q "' .. input.args .. '" --prompt "Scriptnames> "'
            }
        )
    end,
    { nargs = '?', desc = 'Fuzzy :scriptnames' }
)
