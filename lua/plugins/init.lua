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
    require('onedark').load()
    require('onedark').setup  {
        -- Main options --
        style = 'darker'
    }
    use { "ellisonleao/gruvbox.nvim" }
    use 'folke/lsp-colors.nvim'
    require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
    })
    use "EdenEast/nightfox.nvim" -- Packer
    use 'Shatur/neovim-ayu'
    use { 'Everblush/everblush.nvim', as = 'everblush' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'lewis6991/gitsigns.nvim',
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }
    require('gitsigns').setup {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    }

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
        opt = true,
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
    -- use 'airblade/vim-gitgutter' -- plus config
    -- use 'norcalli/nvim-colorizer.lua'
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
