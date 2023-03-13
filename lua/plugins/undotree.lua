vim.g.undotree_DiffCommand = 'diff -u'
vim.g.undotree_WindowLayout = 2
vim.g.undotree_DiffpanelHeight = 14

vim.keymap.set('n', 'gou', ':UndotreeToggle<cr>', {
    desc = 'Visualise the Undo Tree'
})
