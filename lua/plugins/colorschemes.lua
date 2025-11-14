return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            flavor = 'mocha',
            show_end_of_buffer = true,
        },
    },
    {
        'olimorris/onedarkpro.nvim',
        lazy = true,
        priority = 1000,
        opts = {
            colors = {
                onedark = {
                    -- https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/highlights.lua
                    bg = '#1f2329', -- palette/darker/bg0
                    cursorline = '#282c34', -- palette/darker/bg1
                },
            },
            highlights = {
                CursorLineNR = { fg = '#abb2bf' }, -- fg, highlights.lua: CursorLineNR -> fg
            },
            styles = {
                comments = 'italic',
                keywords = 'bold,italic',
                functions = 'italic',
                conditionals = 'italic',
            },
            plugins = {
                all = false,
                blink_cmp = true,
                gitsigns = true,
                hop = true,
                indentline = true,
                mason = true,
                nvim_tree = true,
                treesitter = true,
                trouble = true,
            },
            options = {
                cursorline = true,
            },
        },
    },
    {
        'navarasu/onedark.nvim',
        lazy = true,
        priority = 1000,
        opts = {
            style = 'darker',
            ending_tildes = true,
        },
    },

    { 'Everblush/everblush.nvim', name = 'everblush', lazy = true },
    { 'ellisonleao/gruvbox.nvim', lazy = true },
    { 'savq/melange', lazy = true },
    { 'Shatur/neovim-ayu', lazy = true },
    { 'EdenEast/nightfox.nvim', lazy = true },
}
