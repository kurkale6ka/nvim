local generic = vim.api.nvim_create_augroup("Generic", { clear = true })
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
    command = [[
        if &filetype != 'help'
            silent! cd %:p:h
        endif
    ]],
    group = generic
})

-- Delete EOL white spaces
vim.api.nvim_create_autocmd("BufWritePre", {
    command = [[
        if &filetype != 'markdown'
            call spaces#remove()
        endif
    ]],
    group = generic
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({on_visual = false})
    end,
    group = highlight_group,
})

-- Terminal: no numbers
vim.api.nvim_create_autocmd("TermOpen", {
    command = ':setlocal nonumber norelativenumber',
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

-- -- WSL yank support
-- local clipboard = '/mnt/c/Windows/System32/clip.exe'
-- if vim.fn.executable(clipboard) then
--     vim.api.nvim_create_autocmd("TextYankPost", {
--         callback = function(ev)
--             if v:event['operator'] == 'y' then
--                 vim.fn.system(clipboard, '@0')
--             end
--         end,
--         group = windows
--     })
-- end