local augroup = function(name) return vim.api.nvim_create_augroup(name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

--=== completions ===
autocmd("FileType", {
    group = augroup("completion"),
    desc = "set different completion source based on file types",
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end

        local text_filetype = {
            markdown = true,
            text = true,
            tex = true,
            plaintext = true
        }

        if text_filetype [vim.bo.filetype] then
            vim.opt_local.complete = ".,w,b,u,t,k,kspell,s"
            --.: buffer
            --w: other windows
            --b: other buffers
            --u: unloaded buffers
            --t: tags
            --k: dictionary words
            --kspell: spell dictionary
            --s: spell suggestion
        else
            vim.opt_local.complete = ".,w,b,u,t,i,d,],f"
            --".": current buffer
            --"w": other windows
            --"b": other buffers
            --"u": unloaded buffers
            --"t": tags
            --"i": included files
            --"d": macro/define completion
            --"]": tags with pattern matching
            --"f": filenames
        end
    end,
})

--=== file behaviors ===
--jump to last cursor position when reopening a file
autocmd("BufReadPost", {
    group = augroup("restore_cursor"),
    desc = "restore last cursor position",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, "\"")
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then vim.api.nvim_win_set_cursor(0, mark) end
    end,
})

--remove trailing whitespace on save
--exclude binary/diff/nofile buffers
autocmd("BufWritePre", {
    group = augroup("remove_whitespace"),
    desc = "remove trailing whitespace before saving",
    callback = function()
        if vim.bo.filetype == "diff" or vim.bo.buftype ~= "" then return end
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

--auto-reload file when changed outside
autocmd({ "FocusGained", "BufEnter", "CursorHold" } --[[@as string]], {
    group = augroup("auto_reload"),
    desc = "auto-reload file if changed outside nvim",
    callback = function()
        if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then vim.cmd("silent! checktime") end
    end,
})

--create parent directories automatically when saving a new file
autocmd("BufWritePre", {
    group = augroup("auto_mkdir"),
    desc = "create missing parent directories on save",
    callback = function(args)
        --skip special buffers
        if vim.bo.buftype ~= "" then
            return
        end

        --skip oil, term and so on buffers
        if args.match:match("^%w+://") then
            return
        end

        --skip unnamed buffers
        if args.file == "" then
            return
        end

        local dir = vim.fn.fnamemodify(args.file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
    end,
})

--=== UI ===
--highlight yanked text
autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    desc = "highlight yanked text",
    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 180 }) end,
})

--equalize window sizes when the terminal is resized
autocmd("VimResized", {
    group = augroup("resize_splits"),
    desc = "equalize window splits after terminal resize",
    callback = function() vim.cmd("tabdo wincmd =") end,
})

--close quickfix/location list if it is the last window
autocmd("WinEnter", {
    group = augroup("auto_close_qf"),
    desc = "close quickfix if it is the last window",
    callback = function()
        if vim.bo.buftype == "quickfix" and vim.fn.winnr("$") == 1 then vim.cmd("quit") end
    end,
})

--=== search highlight ===
--clear search highlight when entering insert mode
autocmd("InsertEnter", {
    group = augroup("clear_hlsearch"),
    desc = "clear search highlights on insert",
    callback = function() vim.v.hlsearch = 0 end,
})

--restore search highlight when leaving insert mode
autocmd("InsertLeave", {
    group = augroup("restore_hlsearch"),
    desc = "restore search highlights on leaving insert",
    callback = function() vim.opt.hlsearch = true end,
})

--=== LSP ===
--show diagnostics float automatically on CursorHold
autocmd("CursorHold", {
    group = augroup("show_diagnostic_float"),
    desc = "show diagnostic float on cursor hold",
    callback = function()
        if not vim.diagnostic.is_enabled() then --disable diagnostic
            return
        end

        if #vim.api.nvim_tabpage_list_wins(0) > 1 then --more than one diagnostic floating widnow
            return
        end

        if vim.bo.filetype == "" then return end
        vim.diagnostic.open_float(nil, {focusable = false})
    end,
})

--=== directories ===
--change local working directory to match the current file
autocmd("BufEnter", {
    group = augroup("auto_lcd"),
    desc = "lcd to current file directory",
    callback = function()
        if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then vim.cmd("silent! lcd %:p:h") end
    end,
})

--=== projects ===
--fix Windows ShaDa write failures
autocmd("VimEnter", {
    group = augroup("shada_cleanup"),
    desc = "clean stale ShaDa tmp files on Microsoft Windows",
    once = true,
    callback = function()
        if vim.fn.has("win32") == 0 then return end
        local shada_dir = vim.fn.stdpath("data") .. "\\shada"
        for _, f in ipairs(vim.fn.glob(shada_dir .. "\\main.shada.tmp.*", false, true)) do
            vim.fn.delete(f)
        end
    end,
})

--=== competitive plugin ===
autocmd("BufReadPre", {
    group = augroup("competitive_utf8"),
    desc = "force UTF-8 encoding for competitive programming files",
    pattern = vim.fn.expand("~") .. "/competitive/*",
    callback = function() vim.opt_local.fileencoding = "utf-8" end,
})
