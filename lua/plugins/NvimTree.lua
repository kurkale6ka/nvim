require("nvim-tree").setup {
    view = {
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        icons = {
            glyphs = {
                git = {
                    unstaged = "",
                    staged = "+",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "?",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    filters = {
        dotfiles = true,
    },
}

-- View NvimTree, :Vexplore
vim.keymap.set('n', '<leader>v', ':NvimTreeFindFileToggle<cr>')

-- TODO: nowait?
pcall(vim.keymap.del, { 'n', 'v' }, '-', { buffer = true, nowait = true })
