-- staged = "+",
-- unmerged = "",
-- renamed = "➜",
-- untracked = "??",
-- deleted = "",
-- ignored = "◌",
vim.cmd([[
hi link NvimTreeNormal Normal " TODO: doesn't work
hi NvimTreeGitDirty guifg=#af0000 " unstaged
]])
