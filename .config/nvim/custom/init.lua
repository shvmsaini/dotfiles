vim.opt.undofile = false

-- Automatically open NERDTree on startup
--vim.cmd([[autocmd VimEnter * NVimTree]])

-- Open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            require("nvim-tree").open()
        end
    end,
})


