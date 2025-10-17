-- TODO: add more VeryLazy
return {
    {
        'glacambre/firenvim',
        build = ':call firenvim#install(0)',
        init = function()
            -- force manual triggering
            if vim.fn.exists('g:started_by_firenvim') then
                vim.g.firenvim_config = [[
            {
                'localSettings': {
                    '.*': {
                        'selector': '',
                        'priority': 0,
                    }
                }
            }
            ]]
            end
        end,
        lazy = true,
    },

    -- TODO: 'bfredl/nvim-miniyank', {}
    { 'pearofducks/ansible-vim', lazy = true }, -- let g:ansible_attribute_highlight = "ab"
    { 'rodjek/vim-puppet', lazy = true },
    { 'terceiro/vim-foswiki', lazy = true },
    { 'vim-scripts/iptables', lazy = true },
    { 'vim-scripts/nginx.vim', lazy = true },
    { 'StanAngeloff/php.vim', lazy = true },
    { 'tmux-plugins/vim-tmux', lazy = true },
}
