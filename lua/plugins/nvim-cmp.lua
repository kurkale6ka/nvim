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

-- Filter backup files (*~) out
local function filter_backups_out(entry)
    return not entry:get_word():match('~$')
end

-- cmdline setup
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline {
        -- ['<c-a>'] = cmp.mapping.abort(), -- TODO: c-a is already taken
        -- ['<cr>'] = cmp.mapping.confirm({ select = true }), TODO: confirm cmdline selection with enter. Fix, not working
        ['<c-e>'] = cmp.config.disable,
        ['<c-y>'] = cmp.config.disable,
    },
    sources = cmp.config.sources {
        { name = 'path',
            max_item_count = 20,
            entry_filter = filter_backups_out,
            -- option = { trailing_slash = true }, -- adds a slash but then there is no list of following next items. solved by <tab> in cmp.mapping.confirm but creates other issues
        },
        { name = 'cmdline',
            max_item_count = 20,
            entry_filter = filter_backups_out,
            option = { ignore_cmds = { 'Man', '!' } },
        }
    },
})

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<c-b>']     = cmp.mapping.scroll_docs(-4),
        ['<c-f>']     = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-a>']     = cmp.mapping.abort(),
        ['<cr>']      = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<c-e>']     = cmp.config.disable,
        ['<c-y>']     = cmp.config.disable,
    },
    sources = cmp.config.sources {
        -- { name = 'nvim_lua' }, -- TODO: replace with neodev
        { name = 'nvim_lsp_signature_help',
            -- option = { ignore_functions = { 'print' } }, -- TODO, pull request?
        },
        { name = 'nvim_lsp',
            max_item_count = 10,
        },
        { name = 'buffer',
            max_item_count = 10,
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            },
        },
        { name = 'path',
            max_item_count = 10,
            entry_filter = filter_backups_out,
        },
        { name = 'ultisnips',
            max_item_count = 10,
        },
    },
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            -- This concatenates the icons with the name of the item kind
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            -- Source
            vim_item.menu = ({
                -- nvim_lua  = "[Lua]", -- TODO: [Neodev]
                buffer    = "[Buffer]",
                cmdline   = "[Cmdline]",
                nvim_lsp  = "[LSP]",
                path      = "[Path]",
                ultisnips = "[UltiSnips]",
            })[entry.source.name]
            return vim_item
        end,
    },
}
