---@type vim.lsp.Config
return {
    settings = {
        pyright = {
            disableOrganizeImports = true, -- use isort
        },
        python = {
            analysis = {
                ignore = { '*' }, -- use ruff for linting
            },
        },
    },
}
