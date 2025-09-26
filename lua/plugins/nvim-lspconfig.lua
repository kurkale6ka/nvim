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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities),
    on_attach = on_attach
}

vim.lsp.config('pyright', {
    vim.tbl_extend("error", -- TODO: can we simplify this, and not DRY?
        cmp_capabilities,
        {
            settings = {
                pyright = {
                    disableOrganizeImports = true, -- use isort
                },
                python = {
                    analysis = {
                        ignore = { '*' }, -- use ruff for linting
                    },
                },
            }
        }
    )
})

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
