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
        lualine_a = {
            { 'fileformat',
                fmt = function(str)
                    return vim.o.paste and str .. ' --paste--' or str
                end
            }
        },
        lualine_b = {
            { 'filename',
                fmt = function(str)
                    if vim.b.keymap_name then
                        return str .. ' (' .. vim.b.keymap_name .. ')'
                    else
                        return str
                    end
                end,
                color = function()
                    return { fg = vim.bo.modified and '#ff7575' or '#86bcff' } -- TODO: apply color on [+] only, also for [RO] and keymap
                end,
                symbols = {
                    readonly = '[RO]',
                }
            },
            { 'branch', icon = '', color = { fg = '#18a558' } },
        },
        lualine_c = {
            'diff',
            'diagnostics',
            { '%v', fmt = function(str) return 'col:' .. str end } -- current column
        },
        lualine_x = {
            'searchcount',
            { 'encoding', fmt = function(str) return str:gsub('-', '') end },
            { 'filetype', color = { fg = '#ffab60' } }
        },
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
