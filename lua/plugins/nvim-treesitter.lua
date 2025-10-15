return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            {
                'nvim-treesitter/playground',
                build = ':TSInstall query',
                cmd = 'TSPlaygroundToggle'
            }
        },
        init = function()
            -- TODO: check
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.wo.foldenable = false
        end,
        -- TODO: get rid of the config section + the require?
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "git_rebase",
                    "javascript",
                    "json",
                    "jsonc",
                    "hcl",
                    "vimdoc",
                    "lua",
                    "markdown",
                    "python",
                    "terraform",
                    "vim",
                    "yaml",
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection    = "<c-leader>", -- set to `false` to disable one of the mappings, TODO: map not working
                        node_incremental  = "grn",
                        scope_incremental = "grc",
                        node_decremental  = "grm",
                    },
                },
                indent = {
                    enable = true,
                    -- disable = { "python" }
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            -- ['ia'] = '@attribute.inner',
                            -- ['aa'] = '@attribute.outer',
                            -- ['ib'] = '@block.inner', -- taken: alias for a(
                            -- ['ab'] = '@block.outer',
                            -- ['ic'] = '@call.inner',
                            -- ['ac'] = '@call.outer',
                            ['ic'] = '@class.inner',
                            ['ac'] = '@class.outer',
                            -- ['ac'] = '@comment.outer',
                            ['ii'] = '@conditional.inner', -- inner if
                            ['ai'] = '@conditional.outer',
                            -- ['if'] = '@frame.inner', -- taken: I use 'if' for 'inner file'
                            -- ['af'] = '@frame.outer',
                            ['im'] = '@function.inner', -- method
                            ['am'] = '@function.outer',
                            ['il'] = '@loop.inner',
                            ['al'] = '@loop.outer',
                            ['in'] = '@number.inner',
                            ['ia'] = '@parameter.inner', -- argument
                            ['aa'] = '@parameter.outer',
                            -- ['is'] = '@scope.inner',
                            -- ['as'] = '@statement.outer', -- taken: sentence
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            -- [']c'] = '@class.outer', -- used to jump to diffs with unimpaired, might still work for bothe. TODO: test
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            -- [']C'] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            -- ['[c'] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            -- ['[C'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>x'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>X'] = '@parameter.inner',
                        },
                    }
                }
            }
        end
    }
}
