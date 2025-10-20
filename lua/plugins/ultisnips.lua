local ulti_snips = vim.fn.stdpath('config') .. '/lua/config/UltiSnips'

return {
    {
        'SirVer/ultisnips',
        dependencies = 'honza/vim-snippets',
        init = function()
            vim.g.UltiSnipsSnippetDirectories = { 'UltiSnips', ulti_snips }
            vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_snips
            vim.g.UltiSnipsEnableSnipMate = false
            vim.g.UltiSnipsListSnippets = '<c-r><tab>'
            vim.g.UltiSnipsExpandTrigger = '<tab>'
            vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
        end,
    },
}
