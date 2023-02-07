local comments = vim.api.nvim_create_augroup("Comments", { clear = true })

-- Comment strings
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'cs', 'dot', 'arduino' },
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

-- Start writing comments with \\ and \cs
-- TODO: \cs for java|php: /** ... (documentation comments)
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'cs', 'css', 'php', 'dot', 'java', 'javascript', 'arduino' },
    command = [[
        imap <silent> <buffer> <bslash><bslash> /*  */<left><left><left>
        imap <silent> <buffer> <bslash>cs       /*<cr><cr>/<left><up><space>
    ]],
    group = comments,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'xml', 'xsd', 'phtml', 'xhtml' },
    command = [[
        imap <silent> <buffer> <localleader><localleader> <!--  --><left><left><left><left>
        imap <silent> <buffer> <localleader>cs            <!--<cr><cr>--><left><up>
    ]],
    group = comments,
})
