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

            -- (Default) Only show the documentation popup when manually triggered
            completion = { menu = { auto_show = false } },
            cmdline = { enabled = false },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = { default = { 'lsp', 'path' } },
            signature = {
                enabled = true,
                trigger = { enabled = false },
            },
        },
    },
}
