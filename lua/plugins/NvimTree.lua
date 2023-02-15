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
        -- custom = "\\%(^\\.git\\|.\\+\\~\\)$", -- TODO: not working + why is it needed, .git/ is normally excluded
        dotfiles = true,
    },
}

-- View NvimTree, :Vexplore
vim.keymap.set('n', '<leader>v', ':silent! Glcd <bar> NvimTreeFindFileToggle<cr>',
    { silent = true }
)

vim.o.statusline = "%{&ft}" -- TODO: bg color from 'onedark'
vim.opt_local.fillchars = { eob = " " }

vim.cmd([[
highlight NvimTreeNormal guibg=#1f2329 " onedark/palette/darker/bg0
" highlight link NvimTreeEndOfBuffer NvimTreeNormal " TODO: not working
highlight NvimTreeEndOfBuffer guibg=#1f2329
highlight NvimTreeSymlink guifg=cyan
highlight NvimTreeGitDirty guifg=#af0000 " unstaged
]])
