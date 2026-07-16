return{
    --treesitter core
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            --installed directory where to install parsers and queries
            install_dir = vim.fn.stdpath("data") .. "/treesitter",

            --parsers
            ensure_installed = {
                --programming langusges
                "bash", "c", "cpp", "java", "javascript", "typescript", "tsx", "python", "lua",
                --web
                "html", "css", "vue",
                --configuration
                "xml", "yaml", "properties", "dockerfile", "json", "json5", "jsonc", "toml",
                --database
                "sql", "redis", "nginx",
                --text
                "markdown", "markdown_inline", "latex", "mermaid",
                --build tools
                "cmake", "make",
                --git
                "git_config", "git_rebase", "gitcommit", "gitignore", "diff",
                --vim/neovim
                "vim", "vimdoc", "query",
                --misc
                "regex", "csv"
            },

            --incremental selection
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",--initialize select
                    node_incremental = "<CR>",--expand node
                    scope_incremental = "<Tab>",--expand scope
                    node_decremental = "<S-Tab>"--decrease scope
                }
            }
        },

        config = function(_, opts)
            require("nvim-treesitter.config").setup(opts)

            --enable treesitter folding
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    },
    --treesitter text objects
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        ops = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                }
            },
            select_modes = {
                ["@parameter.outer"] = "v",
                ["@function.outer"] = "V",
                ["@class.outer"] = "<c-v>",
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>rp"] = "@parameter.outer",
                    ["<leader>rf"] = "@function.outer",
                    ["<leader>rc"] = "@class.outer",
                    ["<leader>rl"] = "@loop.outer",
                },
                swap_previous = {
                    ["<leader>rP"] = "@parameter.outer",
                    ["<leader>rF"] = "@function.outer",
                    ["<leader>rC"] = "@class.outer",
                    ["<leader>rL"] = "@loop.outer",
                }
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                    ["[l"] = "@loop.outer",
                    ["[z"] = {query = "@fold", query_group = "folds"}
                },
                goto_next_end = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                    ["]l"] = "@loop.outer",
                    ["]z"] = {query = "@fold", query_group = "folds"}
                },
                goto_previous_start = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                    ["[L"] = "@loop.outer",
                    ["[Z"] = {query = "@fold", query_group = "folds"}
                },
                goto_previous_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                    ["]L"] = "@loop.outer",
                    ["]Z"] = {query = "@fold", query_group = "folds"}
                },
            }
        },
        config = function(_, opts)
            require("nvim-treesitter.config").setup({
                textobjects = opts
            })
        end
    },
    --treesitter context
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        opts = {
            max_lines = 3,--display at most 3 lines 4 context
            trim_scope = "topline",--discard top lines if max_lines is exceeded
            separator = "_"
        },
        keys = {
            {
                "[c",
                function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end,
                desc = "jump to context header",
                mode = "n"
            },
            {
                "]c",
                "<c-o>",
                desc = "back to code",
                mode = "n"
            },
            {
                "<leader>tc",
                "<cmd>TSContext toggle<CR>",
                desc = "toggle treesitter context",
                mode = "n"
            }
        }
    }
}
