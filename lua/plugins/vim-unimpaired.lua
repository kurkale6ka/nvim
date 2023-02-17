-- Remove
vim.keymap.del('n', '[p')
vim.keymap.del('n', ']p')

-- Add
-- custom virtualedit toggle
vim.keymap.set('n', 'yov', ":se <C-R>=(&ve != 'all') ? 've=all' : 've=block'<CR><CR>")

-- mouse toggle
vim.keymap.set('n', 'yom',
    function()
        if vim.o.mouse == 'a' then
            vim.o.mouse = ''
        else
            vim.o.mouse = 'a'
        end
    end,
    { desc = 'Toggle mouse option' }
)
