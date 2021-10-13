local M = {}

-- Color scheme
function M.theme()
    vim.o.termguicolors = true
    vim.o.cursorline = true
    vim.g.material_style = 'oceanic'
    --vim.g.material_style = 'lighter'
    vim.api.nvim_command('colorscheme material')
end

-- Statusline
function M.statusline()
    vim.o.showmode = false
    require('lualine').setup({
        options = {
            theme = 'material-nvim',
            icons_enabled = true,
            disabled_filetypes = { "dashboard", "NvimTree" },
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

end

function M.tabline()
    vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'
end

-- Colorizer
function M.colorizer()
    require('colorizer').setup()
end

return M
