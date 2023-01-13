-- TODO: move to ftplugin?
vim.keymap.set('n', '<Plug>(fern-my-open-expand-collapse)',
    function()
        return vim.fn['fern#smart#leaf'](
            '<Plug>(fern-action-open:select)',
            '<Plug>(fern-action-expand)',
            '<Plug>(fern-action-collapse)'
        )
    end, {
    buffer = true,
    expr = true,
    desc = 'Expand or collapse'
})

vim.keymap.set('n', '<cr>', '<Plug>(fern-my-open-expand-collapse)', {
    buffer = true,
    desc = 'Expand or collapse'
})

vim.keymap.set('n', '<2-LeftMouse>', '<Plug>(fern-my-open-expand-collapse)', {
    buffer = true,
    desc = 'Expand or collapse'
})

vim.keymap.set('n', '*', '<Plug>(fern-action-mark:toggle)', {
    buffer = true,
    desc = 'Mark (toggle)'
})

vim.keymap.set('n', 'u', '<Plug>(fern-action-leave)', {
    buffer = true,
    nowait = true,
    desc = 'Go up by a level, cd ..'
})

vim.keymap.set('n', '<', '<Plug>(fern-action-leave)', {
    buffer = true,
    nowait = true,
    desc = 'Go up by a level, cd ..'
})

vim.keymap.set('n', '>', '<Plug>(fern-action-enter)', {
    buffer = true,
    nowait = true,
    desc = 'Enter directory'
})

vim.keymap.set('n', 'md', '<Plug>(fern-action-new-dir)', {
    buffer = true,
    nowait = true,
    desc = 'md: mkdir'
})

vim.keymap.set('n', 'mv', '<Plug>(fern-action-rename)', {
    buffer = true,
    nowait = true,
    desc = 'mv old new'
})

vim.o.statusline = "%{&ft}" -- TODO: bg color from 'onedark'
vim.wo.number = false
-- vim.wo.signcolumn = false
vim.wo.fillchars = 'eob: '

vim.fn['glyph_palette#apply']()
