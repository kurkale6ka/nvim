require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '❭', right = '❬' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'fern' },
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'fileformat' },
        lualine_b = {
            { 'filename', color = { fg = '#86bcff' } },
            { 'branch', icon = '', color = { fg = '#18a558' } },
        },
        lualine_c = {
            'diff',
            'diagnostics',
            '%v' -- current column, TODO: add 'col: ' (with fmt?)
        },
        lualine_x = { 'encoding', { 'filetype', color = { fg = '#ffab60' } } }, -- TODO: utf-8 -> utf8
        lualine_y = { 'progress' },
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
