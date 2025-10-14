vim.api.nvim_create_user_command('Session',
    'silent! Glcd | Obsession', {
    desc = 'Create Session.vim in the git root folder',
})

return {
    { 'tpope/vim-obsession',
        cmd = 'Obsession'
    }
}
