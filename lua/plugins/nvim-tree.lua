-- TODO: Fix disappearing highlights after save to a file

-- Highlights, FIXME
vim.api.nvim_set_hl(0, 'NvimTreeSymlink', { fg = 'cyan' })
vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { fg = '#e55561' }) --  unstaged
-- vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { link = 'GitSignsDelete' }) -- FIXME: not working?
vim.api.nvim_set_hl(0, 'NvimTreeGitNew', { fg = '#e55561' }) -- ? untracked
vim.api.nvim_set_hl(0, 'NvimTreeNormal', { fg = '#1f2329' }) -- onedark/palette/darker/bg0
vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { fg = '#1f2329', bg = '#1f2329' }) -- change eob bg + hide final tildes by using the same color
-- vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { link = 'NvimTreeNormal' }) -- FIXME: not working?

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
