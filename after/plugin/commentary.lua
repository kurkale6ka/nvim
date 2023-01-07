if not vim.fn.exists("g:loaded_commentary")
then
    vim.fn.finish()
end

-- \\ to toggle comments
vim.keymap.set('n', '<bslash><bslash>', 'gcc', { remap = true })
vim.keymap.set('x', '<bslash><bslash>', 'gc',  { remap = true })
