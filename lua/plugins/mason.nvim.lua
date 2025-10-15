-- TODO: use the API to auto install linters/formatters vs
-- MasonInstall ansible-lint
-- MasonInstall shfmt
-- ...
-- https://github.com/williamboman/mason.nvim/blob/main/doc/reference.md

return {
    {
        'mason-org/mason.nvim', -- automatically install LSPs to stdpath for neovim
        opts = {
            pip = {
                upgrade_pip = true,
            },
        },
    }
}
