return {
    {
        'navarasu/onedark.nvim',
        lazy = false, -- necessary for the main colorscheme
        priority = 1000, -- necessary for the main colorscheme
        opts = {
            -- Main options
            style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
            transparent = false, -- Show/hide background
            term_colors = true, -- Change terminal color as per the selected theme style
            ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
            cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

            -- Change code style
            -- Options are italic, bold, underline, none
            -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
            code_style = {
                comments = 'italic',
                keywords = 'none',
                functions = 'none',
                strings = 'none',
                variables = 'none',
            },

            -- Lualine options
            lualine = {
                transparent = false, -- lualine center bar transparency
            },

            -- -- Custom Highlights
            -- colors = {
            --     myComment = '#517A66',
            -- },
            -- highlights = {
            --     ["@comment"] = { fg = '$myComment' },
            -- },

            -- Plugins Config
            diagnostics = {
                darker = true, -- darker colors for diagnostic
                undercurl = true, -- use undercurl instead of underline for diagnostics
                background = true, -- use background color for virtual text
            },
        },
    },

    { 'Everblush/everblush.nvim', name = 'everblush', lazy = true },
    { 'ellisonleao/gruvbox.nvim', lazy = true },
    { 'savq/melange', lazy = true },
    { 'Shatur/neovim-ayu', lazy = true },
    { 'EdenEast/nightfox.nvim', lazy = true },
}
