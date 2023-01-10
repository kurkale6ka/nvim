local packer = vim.api.nvim_create_augroup('Packer', { clear = true })

-- Automatically source and packer compile on save
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    pattern = '*/lua/plugins/init.lua',
    group = packer,
})

return require('packer').startup(function(use)

    -- Self
    use 'wbthomason/packer.nvim'

    -- Tpope
    use 'tpope/vim-abolish'
    use 'tpope/vim-commentary'
    use 'tpope/vim-endwise'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-markdown'
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-projectionist'

    -- Fern
    use 'lambdalisue/fern.vim'
    use 'lambdalisue/fern-hijack.vim'
    use 'lambdalisue/nerdfont.vim'
    use 'lambdalisue/fern-renderer-nerdfont.vim'
    use 'lambdalisue/glyph-palette.vim'

    use 'liuchengxu/vista.vim'
    use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

    -- Junegunn
    use 'junegunn/vim-easy-align'
    use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
    use 'junegunn/fzf.vim'

    -- LSP
    use { 'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
            'williamboman/mason-lspconfig.nvim',
            'j-hui/fidget.nvim', -- useful status updates for LSP
            'folke/neodev.nvim', -- additional lua configuration, makes nvim stuff amazing
        },
    }

    -- Autocompletion
    use { 'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
    }

    -- Snippets
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'honza/vim-snippets'

    use "savq/melange"

    use 'navarasu/onedark.nvim'
    require('onedark').setup  {
        -- Main options --
        style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false,  -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = 'gs', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        -- toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between
        toggle_style_list = {'darker', 'deep', 'warmer'}, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
        code_style = {
            comments = 'italic',
            keywords = 'none',
            functions = 'none',
            strings = 'none',
            variables = 'none'
        },

        -- Lualine options --
        lualine = {
            transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {
            -- desertString = '#fa8072',
            -- desertComment = '#7ccd7c',
        },
        highlights = {
            -- ["@string"] = {fg = '$desertString'},
            -- ["@comment"] = {fg = '$desertComment', fmt = 'italic'},
        },

        -- Plugins Config --
        diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true,   -- use undercurl instead of underline for diagnostics
            background = true,    -- use background color for virtual text
        },
    }
    require('onedark').load()

    use {'norcalli/nvim-colorizer.lua', opt = true}
    -- require('colorizer').setup()

    use { "ellisonleao/gruvbox.nvim" }

    -- use 'folke/lsp-colors.nvim'
    -- require("lsp-colors").setup()

    use "EdenEast/nightfox.nvim" -- Packer
    use 'Shatur/neovim-ayu'
    use { 'Everblush/everblush.nvim', as = 'everblush' }

    use 'lukas-reineke/indent-blankline.nvim'
    require("indent_blankline").setup()

    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    require('lualine').setup {
        -- ft = { not fern }
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '❭', right = '❬'},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
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
            lualine_a = {'mode'},
            -- lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_b = {'branch'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }

    use { 'lewis6991/gitsigns.nvim',
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }
    require('gitsigns').setup{
        signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '─' }, -- deleted lines under marked line
            topdelete    = { text = '‾' }, -- deleted BOF lines
            changedelete = { text = '~' }, -- deleted some lines above/below then changed line
            untracked    = { text = '?' },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- -- Actions
            -- map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            -- map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            -- map('n', '<leader>hS', gs.stage_buffer)
            -- map('n', '<leader>hu', gs.undo_stage_hunk)
            -- map('n', '<leader>hR', gs.reset_buffer)
            -- map('n', '<leader>hp', gs.preview_hunk)
            -- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            -- map('n', '<leader>tb', gs.toggle_current_line_blame)
            -- map('n', '<leader>hd', gs.diffthis)
            -- map('n', '<leader>hD', function() gs.diffthis('~') end)
            -- map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }

    use { 'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    }
    vim.keymap.set('n', 'gl', ':HopWord<cr>', { desc = 'Go to a random word' })

    use { 'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }

    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use { 'nvim-treesitter/playground',
        after = 'nvim-treesitter',
        run = ':TSInstall query', -- TODO: didn't work
        cmd = 'TSPlaygroundToggle'
    }

    use { 'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end,
        opt = true,
    }

    -- TODO
    -- execute "Plug '".s:vim."/plugged/unicodename', { 'on': 'UnicodeName' }"
    -- execute "Plug '".s:vim."/plugged/win_full_screen', { 'on': 'WinFullScreen' }"
    -- use 'bfredl/nvim-miniyank', {}
    use { 'pearofducks/ansible-vim', opt = true }
    use { 'rodjek/vim-puppet', opt = true }
    use { 'terceiro/vim-foswiki', opt = true }
    use { 'vim-scripts/iptables', opt = true }
    use { 'vim-scripts/nginx.vim', opt = true }
    use { 'StanAngeloff/php.vim', opt = true }
    use { 'tmux-plugins/vim-tmux', opt = true }
    use { 'jvirtanen/vim-hcl', ft = {'tf', 'tfvars', 'hcl'} }

    -- Own
    use 'kurkale6ka/vim-pairs'
    use { 'kurkale6ka/vim-desertEX', branch = 'menu_colors' } -- TODO: use master
    use { 'kurkale6ka/vim-chess', opt = true }

end)
