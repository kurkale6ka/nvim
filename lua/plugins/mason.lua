-- TODO: use the API to auto install linters/formatters vs
-- MasonInstall ansible-lint
-- MasonInstall black
-- MasonInstall shfmt
-- ...
-- https://github.com/williamboman/mason.nvim/blob/main/doc/reference.md
require('mason').setup {
    pip = {
        upgrade_pip = true,
    },
}
