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
}

-- View NvimTree, :Vexplore
vim.keymap.set('n', '<leader>v', ':silent! Glcd <bar> NvimTreeFindFileToggle<cr>',
    { silent = true }
)

-- Custom statusline + remove final tildes
local api = require("nvim-tree.api")
local Event = api.events.Event

api.events.subscribe(Event.TreeOpen, function()
    vim.wo.statusline = "%{&filetype}" -- TODO: bg color from 'onedark'
    vim.opt_local.fillchars = { eob = " " }
end)

-- Highlights
vim.cmd([[
highlight NvimTreeNormal guibg=#1f2329 " onedark/palette/darker/bg0
" highlight link NvimTreeEndOfBuffer NvimTreeNormal " TODO: not working
highlight NvimTreeEndOfBuffer guibg=#1f2329
highlight NvimTreeSymlink guifg=cyan
highlight NvimTreeGitDirty guifg=#af0000 " unstaged
]])
