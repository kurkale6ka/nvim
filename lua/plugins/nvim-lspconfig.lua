local signs = {
    Error = "",
    Warn  = "",
    Hint  = "",
    Info  = "",
}

-- Diagnostic icons
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Diagnostic maps
local opts = { silent = true }

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>q', ':TroubleToggle document_diagnostics<cr>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

    local bufopts = { silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    vim.keymap.set('n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<localleader>wl',
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        bufopts
    )

    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>m', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, bufopts)

    -- TODO: merge?
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.api.nvim_buf_create_user_command(bufnr, 'Format',
        function(args)
            vim.lsp.buf.format {
                async = true,
                range = {
                    ['start'] = { args.line1, 0 }, -- TODO: not sure why start without the wraps doesn't work
                    ['end'] = { args.line2, 0 }
                }
            }
        end,
        { range = '%', desc = 'Format current buffer with LSP' }
    )

    -- Word highlight on hover, TODO: move to init.lua?
    vim.o.updatetime = 250

    if client.server_capabilities.documentHighlightProvider
    then
        local cursor = vim.api.nvim_create_augroup("Word highlight on hover", { clear = true })

        vim.cmd([[
            highlight link LspReferenceRead Visual
            highlight link LspReferenceText Visual
            highlight link LspReferenceWrite Visual
        ]])

        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
            group = cursor
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            buffer = bufnr,
            group = cursor
        })
    end
end

-- Mason lspconfig
local mason_lspconfig = require('mason-lspconfig')

local servers = {
    ansiblels = {},
    bashls = {},
    dockerls = {},
    jsonls = {},
    marksman = {},
    pyright = {},
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        }
    },
    terraformls = {
        -- filetypes = { "terraform", "terraform-vars", "hcl" }
    },
    tflint = {}, -- TODO: this is a 'LS', does it conflict with terraformls? Where to automate linter install?
    vimls = {},
    yamlls = {},
}

-- ensure the above servers are installed
mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup(
            vim.tbl_extend("error",
                {
                    capabilities = capabilities,
                    on_attach = on_attach
                },
                servers[server_name]
            )
        )
    end
}
