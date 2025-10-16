return {
    {
        'junegunn/vim-easy-align',
        init = function()
            -- "EasyAlign a" to align arrows
            --     pattern is: one or more 'dashes' followed by >
            --     'a' stands for arrows (I used '>' previously but it conflicts with 'stick_to_left')
            vim.g.easy_align_delimiters = {
                a = { pattern = [[[-=]\+>]] },
            }
        end,
        cmd = 'EasyAlign',
    },
}
