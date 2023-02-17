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
