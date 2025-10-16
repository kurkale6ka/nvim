return {
    {
        'junegunn/fzf.vim',
        event = 'VeryLazy',
        dependencies = 'junegunn/fzf',
        keys = {
            -- Fuzzy files
            { '<leader>b', ':Buffers<cr>' },
            { '<leader>h', ':History<cr>', { desc = 'recently edited files' } },
            { '<leader>l', ':GFiles<cr>', { desc = 'ls git files' } },
            { '<a-l>', ':GFiles?<cr>', { desc = 'git status' } },
            { '<a-f>', ':silent! Glcd <bar> Files<cr>', { desc = 'search fzf files' } },
            { '<a-t>', ':Filetypes<cr>' },

            -- Fuzzy help
            { 'gh', ':Helptags<cr>', { desc = 'search help files' } },
            {
                '<a-h>',
                function() return ':Files ' .. vim.env.REPOS_BASE .. '/github/help<cr>' end,
                { expr = true, desc = 'own help files' },
            },

            -- Fuzzy grep
            { '<leader>/', ':BLines<cr>', { desc = '/fuzzy' } },
            { '<leader>G', ':BLines <c-r><c-a>', { desc = ':g/fuzzy' } },
            { '<leader>g', ':silent! Glcd <bar> exe "Rg ".input("ripgrep> ")<cr>', { desc = 'ripgrep' } },

            { '<a-c>', ':Commands<cr>' },
            { '<a-d>', ':Diagnostics<cr>', { desc = 'search LSP diagnostics' } },
            { '<a-m>', ':Maps<cr>' },
            { '<a-s>', ':Snippets<cr>' },
            { '<leader>t', ':BTags<cr>', { desc = 'search buffer tags' } },
        },
    },
}
