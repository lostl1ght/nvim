-- Statusline
vim.o.showmode = false
require('lualine').setup({
    options = {
        theme = 'material-nvim',
        icons_enabled = true,
        disabled_filetypes = {'alpha', 'NvimTree',},
    },
    sections = {
        lualine_b = {
            'branch',
        },
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        }
    },
    extensions = {
        'nvim-tree',
    },
})
