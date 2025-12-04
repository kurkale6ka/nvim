vim.filetype.add {
    extension = {
        pgn = 'pgn', -- chess
    },
    filename = {
        ['known_hosts'] = 'known_hosts',
    },
    pattern = {
        ['authorized_keys.*'] = 'authorized_keys',
        ['.*/zsh/autoload/.+'] = 'zsh',
    },
}
