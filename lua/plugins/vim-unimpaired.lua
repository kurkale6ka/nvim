-- TODO: check the maps work

-- Custom virtualedit toggle
vim.keymap.set('n', 'yov', ":se <C-R>=(&ve != 'all') ? 've=all' : 've=block'<CR><CR>")

-- Mouse toggle
vim.keymap.set('n', 'yom',
    function()
        if vim.o.mouse == 'a' then
            vim.o.mouse = ''
            print('Mouse off')
        else
            vim.o.mouse = 'a'
            print('Mouse on')
        end
    end,
    { desc = 'Toggle mouse option' }
)

-- "Kill to eol" toggle
-- allows me to enter digraphs with c-k
vim.keymap.set('n', 'yok',
    function()
        local ok, _ = pcall(vim.keymap.del, 'i', '<c-k>')
        if ok then
            print('"Kill to eol" off')
        else
            vim.keymap.set('i', '<c-k>', '<c-o>D', { desc = 'Kill text (cut) to eol' })
            print('"Kill to eol" on')
        end
    end,
    { desc = '"Kill to eol" toggle' }
)

return {
    {
        'tpope/vim-unimpaired',
        event = "VeryLazy",
    }
}
