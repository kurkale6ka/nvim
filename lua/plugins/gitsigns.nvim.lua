-- FIXME: links to GitSignsAdd
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'GitSignsDelete' })

return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' }, -- deleted lines under marked line, the sign is where the missing line(s) should be! (same for topdelete)
                topdelete = { text = '‾' }, -- deleted BOF lines
                changedelete = { text = '⋍' }, -- deleted some lines above/below then changed line
                untracked = { text = '?' },
            },
            trouble = false, -- TODO: as it doesn't work
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Navigation
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { buffer = bufnr, expr = true })

                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { buffer = bufnr, expr = true })

                -- Actions
                -- vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr })
                -- vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr })
                vim.keymap.set('n', '<leader>p', gs.preview_hunk, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr })
                -- vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr })

                -- Text object
                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
            end,
        },
    },
}
