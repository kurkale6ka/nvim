local comments = vim.api.nvim_create_augroup("Comments", { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'cs', 'dot', 'java', 'arduino' },
    callback = function()
        vim.bo.commentstring = '//%s'
    end,
    group = comments,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql' },
    callback = function()
        vim.bo.commentstring = '--%s'
    end,
    group = comments,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'bindzone' },
    callback = function()
        vim.bo.commentstring = ';%s'
    end,
    group = comments,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'xdefaults' },
    callback = function()
        vim.bo.commentstring = '!%s'
    end,
    group = comments,
})
