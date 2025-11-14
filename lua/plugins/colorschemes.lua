return {
    {
        'olimorris/onedarkpro.nvim',
        priority = 1000,
        opts = {
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
        },
    },
    {
        'catppuccin/nvim',
        lazy = true,
        name = 'catppuccin',
        priority = 1000,
        opts = {
            flavor = 'mocha',
            show_end_of_buffer = true,
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
