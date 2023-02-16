require("nvim-tree").setup {
    view = {
        mappings = {
            list = {
                { key = "!", action = "toggle_dotfiles" },
                { key = "u", action = "dir_up" },
                { key = "-", action = "" },
            },
        },
    },
    renderer = {
        root_folder_label = ':~',
        icons = {
            git_placement = "signcolumn",
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
        custom = { [[^\.git$]] } -- TODO: why is this needed? .git/ is .gitignored!
    },
    update_focused_file = {
        enable = true
    }
}

-- View NvimTree, :Vexplore
vim.keymap.set('n', '<leader>v', ':silent! Glcd <bar> NvimTreeFindFileToggle<cr>',
    { silent = true }
)

-- Highlights
vim.cmd([[
highlight NvimTreeGitDirty guifg=#af0000 "  unstaged
highlight NvimTreeGitNew guifg=#af0000 " ? untracked
highlight NvimTreeSymlink guifg=cyan
highlight NvimTreeNormal guibg=#1f2329 " onedark/palette/darker/bg0
highlight NvimTreeEndOfBuffer guifg=#1f2329 guibg=#1f2329 " change eob bg + hide final tildes by using the same color
" highlight link NvimTreeEndOfBuffer NvimTreeNormal " TODO: not working
]])
