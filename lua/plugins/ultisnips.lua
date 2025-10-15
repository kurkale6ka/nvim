return {
    {
        'SirVer/ultisnips',
        dependencies = 'honza/vim-snippets',
        init = function()
            vim.g.UltiSnipsEnableSnipMate      = false
            vim.g.UltiSnipsListSnippets        = '<c-r><tab>'
            vim.g.UltiSnipsExpandTrigger       = '<tab>'
            vim.g.UltiSnipsJumpForwardTrigger  = '<tab>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
        end
    }
}
