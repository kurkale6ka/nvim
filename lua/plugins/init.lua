local packer = vim.api.nvim_create_augroup('Packer', { clear = true })

-- Automatically source and packer compile on save
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
    pattern = '*/lua/plugins/init.lua',
    group = packer,
})

return require('packer').startup(function(use)

    -- Self
    use 'wbthomason/packer.nvim'

    -- Tpope
    use 'tpope/vim-abolish'
    use 'tpope/vim-characterize'
    use 'tpope/vim-commentary'
    use 'tpope/vim-endwise'
    use 'tpope/vim-fugitive'
    use { 'tpope/vim-markdown', ft = 'markdown' }
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-projectionist'
    require('plugins/sleuth')

    -- Fern
    use { 'lambdalisue/fern.vim',
        requires = {
            { 'lambdalisue/fern-hijack.vim' },
            { 'lambdalisue/nerdfont.vim' },
            { 'lambdalisue/fern-renderer-nerdfont.vim' },
            { 'lambdalisue/glyph-palette.vim' },
        },
    }
    require('plugins/fern')

    use { 'liuchengxu/vista.vim', cmd = 'Vista' }
    use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

    -- Junegunn
    use { 'junegunn/vim-easy-align', cmd = 'EasyAlign' }
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
    require('plugins/nvim-lspconfig')

    -- Tree-sitter
    use { 'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }
    require('plugins/nvim-treesitter')

    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use { 'nvim-treesitter/playground',
        after = 'nvim-treesitter',
        run = ':TSInstall query',
        cmd = 'TSPlaygroundToggle'
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
    require('plugins/nvim-cmp')

    -- Snippets
    use { 'SirVer/ultisnips',
        requires = {
            'quangnguyen30192/cmp-nvim-ultisnips',
            'honza/vim-snippets',
        },
    }
    require('plugins/ultisnips')

    -- Colorschemes
    use 'navarasu/onedark.nvim'
    require('plugins/onedark')

    use { 'Everblush/everblush.nvim', as = 'everblush', opt = true }
    use { 'ellisonleao/gruvbox.nvim', opt = true }
    use { 'savq/melange', opt = true }
    use { 'Shatur/neovim-ayu', opt = true }
    use { 'EdenEast/nightfox.nvim', opt = true }

    -- colors
    use { 'norcalli/nvim-colorizer.lua',
        opt = true,
        conf = function()
            require('colorizer').setup()
        end
    }

    use 'lukas-reineke/indent-blankline.nvim'
    require("indent_blankline").setup()

    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    require('plugins/lualine')

    use { 'lewis6991/gitsigns.nvim' }
    require('plugins/gitsigns')

    use { 'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        cmd = 'HopWord',
        config = function()
            require('plugins/hop')
        end,
    }

    use { 'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end,
        conf = function()
            require('plugins/firenvim')
        end,
        opt = true,
    }

    -- TODO
    -- execute "Plug '".s:vim."/plugged/win_full_screen', { 'on': 'WinFullScreen' }"
    -- use 'bfredl/nvim-miniyank', {}
    use { 'pearofducks/ansible-vim', opt = true }
    use { 'rodjek/vim-puppet', opt = true }
    use { 'terceiro/vim-foswiki', opt = true }
    use { 'vim-scripts/iptables', opt = true }
    use { 'vim-scripts/nginx.vim', opt = true }
    use { 'StanAngeloff/php.vim', opt = true }
    use { 'tmux-plugins/vim-tmux', opt = true }
    use { 'jvirtanen/vim-hcl', ft = 'hcl' }

    -- Own
    use 'kurkale6ka/vim-pairs'
    use { 'kurkale6ka/vim-desertEX', branch = 'menu_colors', opt = true } -- TODO: use master
    use { 'kurkale6ka/vim-chess', opt = true }

end)
