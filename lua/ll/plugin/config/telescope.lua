local present, tele = pcall(require, 'telescope')
if not present then
    return print('telescope not found')
end

-- local telescope_actions = require("telescope.actions.set")
-- local attach_mappings = function(_)
--     telescope_actions.select:enhance({
--         post = function() vim.cmd(":normal! zx zR") end,
--     })
--     return true
-- end
-- Usage: attach_mappings = attach_mappings,

-- Telescope setup
tele.setup({
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            hidden = true,
        },
        help_tags = {
            hidden = true,
            mappings = {
                i = {
                    ['<cr>'] = 'select_tab',
                },
                n = {
                    ['<cr>'] = 'select_tab',
                },
            },
        },
        file_browser = {
            hidden = true,
        },
        oldfiles = {
            hidden = true,
        },
    },
})
