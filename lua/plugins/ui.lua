return{
    --color scheme
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            variant = "dark",
            transparent = true,
            italic_comments = true,
            hide_fillchars = true,
            borderless_pickers = true,

            highlights = {
                --current line number
                CursorLineNr = {
                    fg = "#5ef1ff",
                    bold = true
                },
                --current line
                CursorLine = {
                    bg = "#101827"
                },
                --current column
                CursorColumn = {
                    bg = "#101827"
                },
                --ruler
                ColorColumn = {
                    bg = "#5ef1ff"
                },

                --git signs
                --sign column
                GitSignsAdd = {
                    fg = "#5eff6c"
                },
                GitSignsChange = {
                    fg = "#ffbd5e"
                },
                GitSignsDelete = {
                    fg = "#ff5e5e"
                },
                GitSignsTopdelete = {
                    fg = "#ff5e5e"
                },
                GitSignsChangedelete = {
                    fg = "#ff7b5e"
                },
                GitSignsUntracked = {
                    fg = "#5ef1ff"
                },

                --line number
                GitSignsAddNr = {
                    fg = "#5eff6c"
                },
                GitSignsChangeNr = {
                    fg = "#ffbd5e"
                },
                GitSignsDeleteNr = {
                    fg = "#ff5e5e"
                },

                --whole line highlighting
                GitSignsAddLn = {
                    bg = "#102817"
                },
                GitSignsChangeLn = {
                    bg = "#2a2010"
                },
                GitSignsDeleteLn = {
                    bg = "#2a1015"
                }
            }
        },
        config = function(_, opts)
            require("cyberdream").setup(opts)
            vim.cmd.colorscheme("cyberdream")
        end
    }
}
