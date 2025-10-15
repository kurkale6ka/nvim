-- TODO: check
vim.keymap.set('n', 'gou', ':UndotreeToggle<cr>', {
    desc = 'Visualise the Undo Tree'
})

return {
    {
        'mbbill/undotree',
        init = function()
            vim.g.undotree_DiffCommand = 'diff -u'
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_DiffpanelHeight = 14
        end,
        cmd = { 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus', 'UndotreeToggle' },
        keys = 'gou'
    }
}
