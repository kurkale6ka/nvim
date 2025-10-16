return {
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', lsp_format = 'first' },
                javascript = { 'prettier' },
                javascriptreact = { 'prettier' },
            },
            default_format_opts = {
                lsp_format = 'fallback',
            },
        },
    },
}
