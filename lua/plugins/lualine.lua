local red = '#ff7575'
local comment = '#535965'

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
        lualine_a = { -- paste mode
            function()
                return vim.o.paste and '-- paste --' or ''
            end
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
                    return { fg = vim.bo.modified and red or '#86bcff' } -- TODO: apply color on [+] only, also for [RO] and keymap
                end,
                symbols = {
                    readonly = '[RO]',
                }
            },
            { 'branch', icon = '', color = { fg = '#18a558' } },
        },
        lualine_c = {
            'diagnostics',
            'searchcount',
            { '%v', fmt = function(str) return 'col:' .. str end } -- current column
        },
        lualine_x = {
            { -- LSP server name
                function()
                    local msg = 'no LSP'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return 'LSP: ' .. client.name
                        end
                    end
                    return msg
                end,
                icon = ''
            },
            { -- encoding
                function()
                    local enc, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
                    return enc
                end,
                color = { fg = red }
            },
            { -- fileformat
                function()
                    local ff, _ = vim.bo.fileformat:gsub("^unix$", "")
                    return ff
                end,
                color = { fg = red },
                icon = '␤'
            },
            'diff',
        },
        lualine_y = {
            {
                'filetype', color = { fg = '#ffab60' }
            },
            'progress'
        },
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
    winbar = {
        lualine_b = {
            { -- code context
                function()
                    return '-- ' .. require('nvim-treesitter').statusline()
                end,
                color = { fg = comment },
            }
        },
    },
    inactive_winbar = {
        lualine_b = {
            {
                function()
                    return '-- ' .. require('nvim-treesitter').statusline()
                end,
                color = { fg = comment },
            }
        },
    },
    extensions = {}
}
