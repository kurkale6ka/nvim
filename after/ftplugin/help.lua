vim.keymap.set('n', 'q',
    function()
        vim.cmd('close')
    end, {
    desc = 'Close help windows with "q"'
})
