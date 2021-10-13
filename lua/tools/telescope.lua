local M = {}
-- Telescope setup
function M.setup()
    require('telescope').setup{
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
                        ['<cr>'] = 'select_tab'
                    },
                    n = {
                        ['<cr>'] = 'select_tab'
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
        extensions = {
            project = {
                base_dirs = {
                    '~/code'
                },
                hidden_files = true
            }
        }
    }
end

return M
