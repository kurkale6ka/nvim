if vim.fn.exists("g:loaded_unimpaired")
then
    -- TODO: move to config section in plugins/init.lua
    --       is config in there sourced AFTER a plugin has finished loading?
    pcall(vim.keymap.del, 'n', '[p')
    pcall(vim.keymap.del, 'n', ']p')
end
