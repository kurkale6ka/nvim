local function my_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Custom mappings
    vim.keymap.del('n', '-', { buffer = bufnr })
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up')) -- - by default

    vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', { fg = '#61afef' })
end

-- View NvimTree, :Vexplore
vim.keymap.set('n', '<leader>v', ':silent! Glcd <bar> NvimTreeFindFileToggle!<cr>', { silent = true })

return {
    {
        'nvim-tree/nvim-tree.lua',
        version = '*',
        event = 'VeryLazy',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            on_attach = my_attach,
            renderer = {
                root_folder_label = ':~',
                icons = {
                    git_placement = 'signcolumn',
                    glyphs = {
                        git = {
                            untracked = '?',
                        },
                    },
                },
            },
            filters = {
                custom = { [[^\.git$]] },
            },
            update_focused_file = {
                enable = true,
            },
        },
    },
}
