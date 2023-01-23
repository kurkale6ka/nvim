local fzf = require('fzf-lua')

-- git files
vim.keymap.set('n', '<leader>l', function ()
    fzf.git_files()
end, { desc = 'ls git files' })

-- all files
vim.keymap.set('n', '<leader>sf', function ()
    vim.cmd('Glcd')
    fzf.files {
        fd_opts = '--strip-cwd-prefix -tf -up -E.git -E"*~"',
        rg_opts = "--files -uu -g'!.git' -g'!*~'"
    }
end, { desc = 'search all files' })

-- recently edited files
vim.keymap.set('n', '<leader>h', function ()
    fzf.oldfiles()
end, { desc = 'history search (recently edited files)' })

-- Neovim/plugins help files, TODO: fzf  vim finds 2 extra results ?!
--                                  also, the preview is empty
vim.keymap.set('n', '<leader>sh', function ()
    fzf.help_tags()
end, { desc = 'search help files' })

vim.keymap.set('n', 'gh', ':Files '..vim.env.XDG_CONFIG_HOME..'/repos/help<cr>') -- own help files
vim.keymap.set('n', '<leader>sd', function ()
    fzf.diagnostics_document()
end, { desc = 'search snippets' })
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
