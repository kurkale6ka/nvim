-- Not really needed with LSP's code format
vim.api.nvim_buf_create_user_command(0, 'Tidy', '<line1>,<line2>! python -mjson.tool', {
    range = '%',
    nargs = '*',
    desc = "Beautify json code using python's json module",
})
