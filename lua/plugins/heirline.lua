return{
    {
        "rebelot/heirline.nvim",
        opts = function()
            --constants
            local utils = require("heirline.utils")
            local MiniIcons = require("mini.icons")

            --========= components =========
            --===separators
            local Left_Separator = {
                provider = " 󰽧 ",
                hl = function()
                    return{
                        fg = "cyan"
                    }
                end
            }

            local Right_Separator = {
                provider = " 󰽥 ",
                hl = function()
                    return{
                        fg = "cyan"
                    }
                end
            }

            --===VIM Mode===
            local VimMode = {
                init = function(self)
                    self.mode = vim.fn.mode(1)--get current mode name
                end,

                static = {
                    mode_names = {
                        --===NORMAL MODES
                        n = "N",--normal
                        niI = "NI",--normal insert
                        niR = "NR",--normal replace
                        niV = "NV",--normal visual
                        nt = "NT",--normal terminal
                        --OPERATOR PENDING
                        no = "O",--operator-pending
                        nov = "Ov",--operator-pending(charwise visual)
                        noV = "OV",--operator-pending(linewise visual)
                        ["no\22"] = "O^v",--operator-pending(blockwise visual)

                        --===VISUAL
                        v = "v",--visual charwise
                        V = "V",--visual linewise
                        ["\22"] = "^v",--visual blockwise
                        vs = "vs",--visual select
                        Vs = "Vs",--visual line select
                        ["\22s"] = "^vs",--visual block select

                        --===SELECT
                        s = "s",--select charwise
                        S = "S",--select linewise
                        ["\19"] = "^s",--select blockwise

                        --===INSERT
                        i = "I",--insert
                        ic = "Ic",--insert completion
                        ix = "Ix",--insert completion finished

                        --===REPLACE
                        R = "R",--replace
                        Rc = "Rc",--replace completion
                        Rx = "Rx",--replace completion finished
                        Rv = "Rv",--visual replace
                        Rvc = "Rvc",--visual replace completion
                        Rvx = "Rvx",--visual replace completion finished

                        --===COMMAND
                        c = "C",--command
                        cv = ":",--ex mode
                        ["!"] = "!",--shell command

                        --PROMPT
                        r = "...",--press enter prompt
                        rm = "M",--more prompt
                        ["r?"] = "?",--confirmation prompt

                        --TERMINAL
                        t = "T",--terminal
                    },

                    --foreground colors
                    mode_colors = {
                        n = "cyan",
                        i = "green",
                        v = "yellow",
                        V = "yellow",
                        ["\22"] = "yellow",
                        c = "red",
                        s = "purple",
                        S = "purple",
                        ["\19"] = "purple",
                        R = "orange",
                        r = "orange",
                        ["!"] = "red",
                        t = "blue",
                    },
                },

                --displaying string in the status line
                provider = function(self)
                    --keep at least 2 characters 4 mode name
                    return "%2(" .. (self.mode_names [self.mode] or "?") .. "%)"
                end,

                --highlight the component
                hl = function(self)
                    return {
                        fg = self.mode_colors [self.mode:sub(1, 1)] or "white",--just pass the first char
                        bold = true,
                    }
                end,

                --update only when mode changes
                update = {
                    "ModeChanged",
                    pattern = "*:*",
                    callback = vim.schedule_wrap(function()
                        vim.cmd("redrawstatus")--redraw the status line
                    end),
                },
            }

            --===file icon and name
            local FileIconName = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(0)

                    if self.filename == "" then
                        self.filename = "[New File]"
                        self.icon = ""
                        self.icon_hl = nil
                        return
                    end

                    local icon, hl = MiniIcons.get("file", self.filename)
                    self.icon = icon
                    self.icon_hl = hl
                end,

                provider = function(self)
                    if self.filename == "[New File]" then
                        return self.icon .. " " .. self.filename
                    end

                    --relative path
                    local path = vim.fn.fnamemodify(self.filename, ":.")

                    --cross-platform path separator
                    local sep = package.config:sub(1, 1)

                    local parts = vim.split(path, vim.pesc(sep))

                    if #parts == 0 then
                        return self.icon .. " " .. path
                    end

                    local width = vim.api.nvim_win_get_width(0)

                    local display = width >= 180
                                        and table.concat(parts, sep)
                                        or width >= 140 and #parts > 5
                                            and "..." .. sep .. table.concat(vim.list_slice(parts, -5), sep)
                                            or width >= 110 and #parts > 4
                                                and "..." .. sep .. table.concat(vim.list_slice(parts, -4), sep)
                                                or width >= 80 and #parts > 3
                                                    and "..." .. sep .. table.concat(vim.list_slice(parts, -3), sep)
                                                    or width >= 60 and #parts > 2
                                                        and "..." .. sep .. table.concat(vim.list_slice(parts, -2), sep)
                                                        or parts [#parts]

                    return string.format("%s %s", self.icon, display)
                end,

                hl = function(self)
                    local hl = {}

                    --inherit icon color from mini.icons
                    if self.icon_hl then
                        local ok, group = pcall(utils.get_highlight, self.icon_hl)
                        if ok then
                            hl.fg = group.fg
                        end
                    end

                    --bold when modified
                    if vim.bo.modified then
                        hl.bold = true
                    end

                    --italic during prompt modes
                    local mode = vim.fn.mode(1)

                    if mode == "r" or mode == "rm" or mode == "r?" then
                        hl.italic = true
                    end

                    return hl
                end,

                update = {
                    "BufEnter",
                    "BufWritePost",
                    "BufModifiedSet",
                    "ModeChanged",
                    "DirChanged",
                }
            }

            return{
                --status line UI
                statusline = {
                    VimMode,
                    Left_Separator,
                    FileIconName
                },

                -- --winbar UI
                -- winbar = {},
                --
                -- --tab line UI
                -- tabline = {},
                --
                -- --status column UI
                -- statuscolumn = {}
            }
        end,
    }
}
