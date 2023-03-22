vim.filetype.add {
    extension = {
        ftl = 'xml',
        pgn = 'pgn', -- chess
        tfvars = 'terraform',
        tfbackend = 'terraform'
    },
    filename = {
        ['.gitlab-ci.yml'] = 'yaml', -- needed because the yaml.ansible pattern could match
        ['iptables'] = 'iptables',
        ['known_hosts'] = 'known_hosts',
        ['relayd.conf'] = 'pf',
    },
    pattern = {
        ['authorized_keys.*'] = 'authorized_keys',
        ['.*/postfix/aliases'] = 'mailaliases',
        ['r?syslog.*%.conf'] = 'syslog',
        ['.*/.*ansible.*/.+%.yml'] = 'yaml.ansible',
        ['.*/zsh/autoload/.+'] = 'zsh',
        ['.*/zsh/after/.+'] = 'zsh'
    },
}
