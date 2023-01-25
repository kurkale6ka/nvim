local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    { 'dstein64/vim-startuptime', cmd = 'StartupTime' },

    -- Tpope
    { 'tpope/vim-abolish', cmd = { 'Abolish', 'Subvert' }, keys = 'cr' },
    { 'tpope/vim-characterize', keys = 'ga' },
    { 'tpope/vim-commentary', cmd = 'Commentary', keys = { { 'gc', mode = { 'o', 'n', 'x' } } } },
    'tpope/vim-endwise',
    'tpope/vim-fugitive',
    { 'tpope/vim-markdown', ft = 'markdown' },
    { 'tpope/vim-obsession',
        cmd = 'Obsession',
        config = function()
            require('plugins/session')
        end
    },
    'tpope/vim-repeat',
    { 'tpope/vim-sleuth', cmd = 'Sleuth',
        config = function()
            require('plugins/sleuth')
        end
    },
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-projectionist',

    -- Fern
    { 'lambdalisue/fern.vim',
        lazy = true,
        cmd = 'Fern',
        keys = '<leader>v',
        dependencies = {
            { 'lambdalisue/fern-hijack.vim' },
            { 'lambdalisue/nerdfont.vim' },
            { 'lambdalisue/fern-renderer-nerdfont.vim' },
            { 'lambdalisue/glyph-palette.vim' },
        },
        config = function()
            require('plugins/fern')
        end
    },

    { 'liuchengxu/vista.vim', cmd = 'Vista' },

    -- Junegunn
    { 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
    { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end },
    'junegunn/fzf.vim',

    -- LSP
    { 'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
            'williamboman/mason-lspconfig.nvim',
            'j-hui/fidget.nvim', -- useful status updates for LSP
            'folke/neodev.nvim', -- additional lua configuration, makes nvim stuff amazing
        },
        config = function()
            require('plugins/nvim-lspconfig')
        end
    },

    -- Tree-sitter
    { 'nvim-treesitter/nvim-treesitter',
        build = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            { 'nvim-treesitter/playground',
                build = ':TSInstall query',
                cmd = 'TSPlaygroundToggle'
            }
        },
        config = function()
            require('plugins/nvim-treesitter')
        end
    },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
        config = function()
            require('plugins/nvim-cmp')
        end
    },

    -- Snippets
    { 'SirVer/ultisnips',
        dependencies = {
            'quangnguyen30192/cmp-nvim-ultisnips',
            'honza/vim-snippets',
        },
        config = function()
            require('plugins/ultisnips')
        end
    },

    -- Colorschemes
    { 'navarasu/onedark.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('plugins/onedark')
        end,
    },

    { 'Everblush/everblush.nvim', name = 'everblush', lazy = true },
    { 'ellisonleao/gruvbox.nvim', lazy = true },
    { 'savq/melange', lazy = true },
    { 'Shatur/neovim-ayu', lazy = true },
    { 'EdenEast/nightfox.nvim', lazy = true },

    -- colors
    { 'norcalli/nvim-colorizer.lua',
        lazy = true,
        config = function()
            require('colorizer').setup()
        end
    },

    -- Misc
    { 'lewis6991/gitsigns.nvim',
        config = function()
            require('plugins/gitsigns')
        end
    },

    { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_trailing_blankline_indent = false,
            }
        end,
    },

    { 'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        cmd = 'HopWord',
        keys = 'gs',
        config = function()
            require('plugins/hop')
        end,
    },

    { 'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins/lualine')
        end
    },

    { 'glacambre/firenvim',
        build = function() vim.fn['firenvim#install'](0) end,
        lazy = true,
        config = function()
            require('plugins/firenvim')
        end,
    },

    -- TODO: 'bfredl/nvim-miniyank', {}
    { 'pearofducks/ansible-vim', lazy = true }, -- let g:ansible_attribute_highlight = "ab"
    { 'rodjek/vim-puppet', lazy = true },
    { 'terceiro/vim-foswiki', lazy = true },
    { 'vim-scripts/iptables', lazy = true },
    { 'vim-scripts/nginx.vim', lazy = true },
    { 'StanAngeloff/php.vim', lazy = true },
    { 'tmux-plugins/vim-tmux', lazy = true },

    -- Own
    'kurkale6ka/vim-pairs',
    { 'kurkale6ka/vim-desertEX', branch = 'menu_colors', lazy = true }, -- TODO: use master
    { 'kurkale6ka/vim-chess', lazy = true },

})
