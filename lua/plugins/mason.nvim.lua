-- TODO: use the API to auto install linters/formatters vs:
--
-- MasonInstall ansible-lint
-- MasonInstall shfmt
-- ...

return {
    {
        'mason-org/mason.nvim', -- automatically install LSPs to stdpath for neovim
        opts = {
            pip = {
                upgrade_pip = true,
            },
        },
    },
}
