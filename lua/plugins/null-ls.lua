vim.keymap.set('n', '<leader>f',
    vim.lsp.buf.format,
    { desc = 'Format function provided by null-ls' }
)

vim.keymap.set('n', '<leader>ca',
    vim.lsp.buf.code_action,
    { desc = 'Code actions provided by null-ls' }
)

local null_ls = require("null-ls")

null_ls.setup {
    sources = {
        null_ls.builtins.formatting.isort, -- python
        null_ls.builtins.formatting.packer,
        -- null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.shfmt.with {
            args = { "-i", "4" },
        },
    },
}
