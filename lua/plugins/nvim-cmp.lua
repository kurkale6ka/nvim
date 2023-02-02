local cmp = require('cmp')

local kind_icons = {
    Text          = "",
    Method        = "",
    Function      = "",
    Constructor   = "",
    Field         = "",
    Variable      = "",
    Class         = "ﴯ",
    Interface     = "",
    Module        = "",
    Property      = "ﰠ",
    Unit          = "",
    Value         = "",
    Enum          = "",
    Keyword       = "",
    Snippet       = "",
    Color         = "",
    File          = "",
    Reference     = "",
    Folder        = "",
    EnumMember    = "",
    Constant      = "",
    Struct        = "",
    Event         = "",
    Operator      = "",
    TypeParameter = "",
}

-- cmdline setup
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        -- TODO: confirm cmdline selection with enter. Fix, not working
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'path',
            entry_filter = function(entry) -- TODO: remove repetition, group sections?
                return not entry:get_word():match('~$')
            end,
            max_item_count = 20,
        }
    }, {
        { name = 'cmdline',
            entry_filter = function(entry)
                return not entry:get_word():match('~$')
            end,
            max_item_count = 20,
            option = { ignore_cmds = { 'Man', '!' } }
        }
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons, TODO: kind - variable?
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            -- Source
            vim_item.menu = ({
                cmdline = "[Cmdline]",
            })[entry.source.name]
            return vim_item
        end,
    },
})

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<c-b>']     = cmp.mapping.scroll_docs(-4),
        ['<c-f>']     = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-e>']     = cmp.mapping.abort(),
        ['<cr>']      = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        -- { name = 'nvim_lua' }, TODO: replace with neodev
        { name = 'nvim_lsp', max_item_count = 10 },
        { name = 'buffer',
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            },
            max_item_count = 10
        },
        { name = 'path', max_item_count = 10,
            entry_filter = function(entry)
                return not entry:get_word():match('~$')
            end,
        },
        { name = 'ultisnips', max_item_count = 10 },
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            -- This concatonates the icons with the name of the item kind
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            -- Source
            vim_item.menu = ({
                -- nvim_lua  = "[Lua]", TODO: [Neodev]
                nvim_lsp  = "[LSP]",
                buffer    = "[Buffer]",
                path      = "[Path]",
                ultisnips = "[UltiSnips]",
            })[entry.source.name]
            return vim_item
        end,
    },
})
