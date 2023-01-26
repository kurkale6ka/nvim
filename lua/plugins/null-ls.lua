vim.keymap.set('n', '<leader>f',
    vim.lsp.buf.format,
    { desc = 'Format function provided by null-ls' }
)

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.packer,
    },
})
