-- TODO: add more verylazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {

    defaults = { lazy = true },

    -- Plugins
    { 'dstein64/vim-startuptime',
        cmd = 'StartupTime'
    },

    -- Tpope
    { 'tpope/vim-abolish',
        cmd = { 'Abolish', 'Subvert' },
        keys = 'cr'
    },

    { 'tpope/vim-characterize',
        keys = 'ga'
    },

    { 'tpope/vim-commentary',
        cmd = 'Commentary',
        keys = {
            { 'gc', mode = { 'o', 'n', 'x' } },
            { '\\', mode = { 'o', 'n', 'x' } },
        },
        config = function()
            require('plugins/vim-commentary')
        end
    },

    'tpope/vim-endwise',

    { 'tpope/vim-eunuch',
        cmd = {
            'Cfind', 'Chmod', 'Clocate', 'Copy', 'Delete', 'Duplicate', 'Lfind',
            'Llocate', 'Mkdir', 'Move', 'Remove', 'Rename', 'SudoEdit', 'SudoWrite', 'Unlink', 'Wall'
        }
    },

    { 'tpope/vim-fugitive',
        event = "VeryLazy"
    },

    { 'tpope/vim-markdown',
        ft = 'markdown'
    },

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

    { 'tpope/vim-surround',
        config = function()
            require('plugins/vim-surround')
        end
    },

    { 'tpope/vim-unimpaired',
        event = "VeryLazy",
        config = function()
            require('plugins/vim-unimpaired')
        end
    },

    'tpope/vim-projectionist',

    -- Nvim Tree
    { 'nvim-tree/nvim-tree.lua',
        event = "VeryLazy",
        config = function()
            require('plugins/NvimTree')
        end
    },

    { 'liuchengxu/vista.vim',
        cmd = 'Vista'
    },

    -- Junegunn
    { 'junegunn/vim-easy-align',
        cmd = 'EasyAlign',
        config = function()
            require('plugins/vim-easy-align')
        end
    },

    { 'junegunn/fzf.vim',
        event = "VeryLazy",
        dependencies = {
            { 'junegunn/fzf',
                build = function()
                    vim.fn['fzf#install']()
                end
            },
        },
    },

    -- LSP
    { 'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
                config = function()
                    require('plugins/mason')
                end
            },
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', -- useful LSP status updates
                config = function()
                    require('fidget').setup()
                end
            },
            { 'folke/neodev.nvim', -- additional lua configuration, makes nvim stuff amazing
                config = function()
                    require('neodev').setup()
                end
            },
        },
        config = function()
            require('plugins/nvim-lspconfig')
        end
    },

    { 'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('plugins/null-ls')
        end
    },

    { 'folke/trouble.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons' -- TODO: plugin shouldn't complain as I've manually installed Nerd Fonts, issue?
        },
        cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
        config = function()
            require('plugins/trouble')
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
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-path',
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
        lazy = false, -- necessary for the main colorscheme
        priority = 1000, -- necessary for the main colorscheme
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
        build = function()
            vim.fn['firenvim#install'](0)
        end,
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

    -- Own and local
    'kurkale6ka/vim-pairs',
    { 'kurkale6ka/vim-desertEX', lazy = true },
    { 'kurkale6ka/vim-chess', lazy = true },

}
