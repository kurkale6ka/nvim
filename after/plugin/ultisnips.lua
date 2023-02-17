if vim.fn.exists("did_plugin_ultisnips")
then
    -- override this: :call UltiSnips#SaveLastVisualSelection()<CR>gvs
    vim.keymap.set('x', '<tab>', '>')
end
