---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                -- fixes @type diagnostics errors
                library = {
                    '$VIMRUNTIME',
                    '$XDG_DATA_HOME/nvim/lazy',
                },
            },
        },
    },
}
