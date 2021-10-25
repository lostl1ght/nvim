local present, tele = pcall(require, 'telescope')
if not present then
    return print('telescope not found')
end

local telescope_actions = require("telescope.actions.set")

local attach_mappings = function(_)
    telescope_actions.select:enhance({
        post = function()	vim.cmd(":normal! zx zR") end,
    })
    return true
end

-- Telescope setup
tele.setup{
    pickers = {
        find_files = {
            hidden = true,
            attach_mappings = attach_mappings,
        },
        live_grep = {
            hidden = true,
            attach_mappings = attach_mappings,
        },
        help_tags = {
            hidden = true,
            attach_mappings = attach_mappings,
            mappings = {
                i = {
                    ['<cr>'] = 'select_tab'
                },
                n = {
                    ['<cr>'] = 'select_tab'
                },
            },
        },
        file_browser = {
            attach_mappings = attach_mappings,
            hidden = true,
        },
        oldfiles = {
            attach_mappings = attach_mappings,
            hidden = true,
        },
    },
}
