-- TODO: add for fugitive, git, ... filetypes
vim.keymap.set('n', 'q',
    function()
        vim.cmd('close')
    end, {
    buffer = true,
    desc = 'Close help windows with "q"'
})
