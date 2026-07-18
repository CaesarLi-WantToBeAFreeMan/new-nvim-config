return{
    --git signs and hunks
    {
        "lewis6991/gitsigns.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            attach_to_untracked = true,
            --blames
            current_line_blame = true,--show changed author & date & commit
            current_line_blame_opts = {
                delay = 300,--default is 1,000 milliseconds
                ignore_whitespace = true,--ignore whitesapces when running blame
                use_focus = true--only display blame when the buffer is in focus
            },
            current_line_blame_formatter = "<author> (<author_mail>, <author_tz>) • <author_time:%R (%a %b/%d/%y %I:%M:%S %p)> • <summary> (<abbrev_sha>) x <committer> (<committer_mail>, <committer_tz>) • <committer_time:%R (%a %b/%d/%y %I:%M:%S %p)>",
            current_line_blame_formatter_nc = "<author> (<author_mail>, <author_tz>) • <author_time:%R (%a %b/%d/%y %I:%M:%S %p)>"
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
            {
                "]h",
                function()
                    require("gitsigns").next_hunk()
                end,
                desc = "jump to next hunk"
            },
            {
                "[h",
                function()
                    require("gitsigns").prev_hunk()
                end,
                desc = "jump to previous hunk"
            },
            {
                "<leader>gp",
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "preview hunk"
            },
            {
                "<leader>gtb",
                function()
                    require("gitsigns").toggle_current_line_blame()
                end,
                desc = "toggle current line blame"
            },
            {
                "<leader>gts",
                function()
                    require("gitsigns").toggle_signs()
                end,
                desc = "toggle sign column"
            },
            {
                "<leader>gtw",
                function()
                    require("gitsigns").toggle_word_diff()
                end,
                desc = "toggle word diff"
            },
            {
                "<leader>gtl",
                function()
                    require("gitsigns").toggle_linehl()
                end,
                desc = "toggle whole line highlight"
            }
        }
    },
    --lazygit
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        opts = {
            floating_window_winblend = 0.8
        },
        keys = {
            {"<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit"}
        }
    }
}
