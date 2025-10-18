return {
    {
        'saghen/blink.cmp',
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<C-k>'] = false,
                ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },
            completion = { menu = { auto_show = false } },
            sources = { default = { 'lsp', 'path' } },
            signature = {
                enabled = true,
                trigger = { enabled = false },
            },
            cmdline = { enabled = false },
        },
    },
}
