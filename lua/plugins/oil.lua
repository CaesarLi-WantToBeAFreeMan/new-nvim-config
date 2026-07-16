return{
    {
        "stevearc/oil.nvim",
        dependencies = {
            "nvim-mini/mini.icons"
        },
        lazy = false,
        opts = {
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime"
            },

            delete_to_trash = true,--delete files to trash instead of permanently deleting them

            float = {
                border = "rounded",
                win_options = {
                    winblend = 21
                },

            },

            view_options = {
                natural_order = true
            },

            keymaps_help = {
                border = "rounded"
            },

            keymaps = {
                ["<C-s>"] = false,
                ["<C-v>"] = {"actions.select", opts = {vertical = true}},
                ["gp"] = {"actions.parent", mode = "n"},
                ["gc"] = {"actions.open_cwd", mode = "n"},
                ["gd"] = {"actions.cd", mode = "n"},
                ["g."] = false,
                ["<leader>t."] = {"actions.toggle_hidden", mode = "n"},
                ["<leader>tt"] = {"actions.toggle_trash", mode = "n"}
            },
        },


        keys = {

            {
                "-",
                function()
                    require("oil").open_float()
                end,
                desc = "open oil in floating window"
            },
        }
    }
}
