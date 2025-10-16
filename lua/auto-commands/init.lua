local generic = vim.api.nvim_create_augroup("Generic", { clear = true })
local commit = vim.api.nvim_create_augroup("Commit", { clear = true })
local terminal = vim.api.nvim_create_augroup("Terminal", { clear = true })
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- local windows = vim.api.nvim_create_augroup("Windows", { clear = true })

-- Jump to the last spot the cursor was at in a file when reading it
vim.api.nvim_create_autocmd("BufReadPost", {
    command = [[
        if line("'\"") > 0 && line("'\"") <= line('$') && &filetype != 'gitcommit'
            execute 'normal! g`"'
        endif
    ]],
    group = generic
})

-- When reading a file, :cd to its parent directory.
-- this replaces 'autochdir which doesn't work properly.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        if vim.bo.filetype ~= 'help' and vim.bo.filetype ~= 'man' then
            pcall(vim.fn.chdir, vim.fs.dirname(args.file))
        else
            vim.cmd('wincmd H | vert resize ' .. vim.env.MANWIDTH) -- TODO: fix error with gO then :q
        end
    end,
    group = generic
})

-- Delete EOL white spaces
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.bo.filetype ~= 'markdown' then
            vim.fn['spaces#remove']()
        end
    end,
    group = generic
})

-- VCS (git/svn/...) commit messages
vim.api.nvim_create_autocmd('Filetype', {
    pattern = { 'gitcommit', 'svn' },
    command = [[
        goto
        setlocal spell foldmethod&
        startinsert
    ]],
    group = commit,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
})

-- Terminal: no numbers
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
    group = terminal
})

-- -- Syntax based omni completion
-- vim.api.nvim_create_autocmd("Filetype", {
--     command = [[
--         if empty(&omnifunc)
--             setlocal omnifunc=syntaxcomplete#Complete
--         endif
--     ]],
--     group = generic
-- })
