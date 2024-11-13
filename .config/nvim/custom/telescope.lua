-- ~/.config/nvim/lua/custom/telescope.lua

local telescope = require('telescope')

telescope.setup {
    defaults = {
        -- other default settings
        file_ignore_patterns = {"node_modules", ".git/"},
    },
    pickers = {
        find_files = {
            find_command = {'rg', '--files', '--hidden', '--follow', '--glob', '!.git/*'},
        },
    },
}

-- Optionally, you can set up key mappings for Telescope
--local actions = require('telescope.actions')
--require('telescope').load_extension('fzf') -- if you are using fzf

-- Example key mapping
--vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })

