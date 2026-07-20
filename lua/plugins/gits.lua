return{
    --git signs and hunks
    {
        "lewis6991/gitsigns.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            attach_to_untracked = true,
            --blames
            current_line_blame = true,--shoe current line blame
            current_line_blame_opts = {
                delay = 300,--default is 1,000 milliseconds
                ignore_whitespace = true,--ignore whitesapces when running blame
                use_focus = true--only display blame when the buffer is in focus
            },
            current_line_blame_formatter = "<author> (<author_mail>) • <author_time:%R> • <summary> (<abbrev_sha>)",
            --preview
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 1,
                col = 1
            },
            diffthis = {
                split = "belowright"--open diff buffer in below/right window
            },
            count_chars = {
                {
                    "󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰",
                    ["+"] = "󰲲"
                }
            }
        },
        keys = {
            --hunks
            {
                "]h",
                ":Gitsigns next_hunk<CR>",
                desc = "jump to next hunk"
            },
            {
                "[h",
                ":Gitsigns prev_hunk<CR>",
                desc = "jump to previous hunk"
            },

            --previews
            {
                "<leader>gph",
                ":Gitsigns preview_hunk<CR>",
                desc = "preview hunk"
            },
            {
                "<leader>gpb",
                ":Gitsigns blame_line<CR>",
                desc = "preview blame"
            },

            --toggles
            {
                "<leader>gtb",
                ":Gitsigns toggle_current_line_blame<CR>",
                desc = "toggle current line blame"
            },
            {
                "<leader>gts",
                ":Gitsigns toggle_signs<CR>",
                desc = "toggle sign column"
            },
            {
                "<leader>gtw",
                ":Gitsigns toggle_word_diff<CR>",
                desc = "toggle word diff"
            },
            {
                "<leader>gtl",
                ":Gitsigns toggle_linehl<CR>",
                desc = "toggle whole line highlight"
            },

            --text object
            {
                "ih",
                ":Gitsigns select_hunk<CR>",
                desc = "select hunk text object",
                mode = {"o", "x"}
            }
        }
    },
    --git interface
    {
        "NeogitOrg/neogit",
        lazy = true,
        cmd = "Neogit",
        dependencies = {},
        opts = {
            commit_order = "date",--chronological commit order
            init_branch_name = "main",
            disable_line_numbers = false,--show line numbers
            disable_relative_line_numbers = false,--show relative line numbers
        },
        keys = {
            {
                "<leader>ng",
                ":Neogit<CR>",
                desc = "show neogit UI"
            }
        }
    }
}
