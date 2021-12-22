if not pcall(require, 'feline') then
    return print('feline not found')
end

vim.o.termguicolors = true
vim.o.showmode = false

local colors = {
    bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'bg#'),
    fg = '#abb2bf',
    yellow = '#e0af68',
    cyan = '#56b6c2',
    green = '#98c379',
    orange = '#d19a66',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#61afef',
    red = '#e86671',
}

local vi_mode_colors = {
    NORMAL = colors.green,
    INSERT = colors.red,
    VISUAL = colors.magenta,
    OP = colors.green,
    BLOCK = colors.blue,
    REPLACE = colors.violet,
    ['V-REPLACE'] = colors.violet,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.green,
    SHELL = colors.green,
    TERM = colors.green,
    NONE = colors.yellow,
}

local os_info = function()
    return vim.bo.fileformat
end

local os_icon = function()
    local os = os_info()
    if os == 'unix' then
        return ' '
    elseif os == 'mac' then
        return ' '
    else
        return ' '
    end
end

local ro_icon = function()
    return vim.bo.ro and '' or ''
end

local file_type = function()
    local name = vim.fn.expand('%:t')
    local ext = vim.fn.expand('%:e')
    local icon, _ = require('nvim-web-devicons').get_icon(name, ext, { default = true })
    return icon .. ' ' .. vim.bo.filetype
end

local lsp_get_diag = function(str)
    local count = vim.lsp.diagnostic.get_count(0, str)
    return (count > 0) and ' ' .. count .. ' ' or ''
end

local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local comps = {
    vi_mode = {
        left = {
            provider = function()
                return ro_icon() .. ' ' .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color(),
                    style = 'bold',
                }
                return val
            end,
            left_sep = ' ',
        },
        right = {
            provider = function()
                return os_icon() .. os_info()
            end,
            hl = function()
                return {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color(),
                    style = 'bold',
                }
            end,
            left_sep = ' ',
            right_sep = ' ',
        },
    },
    file = {
        info = {
            provider = {
                name = 'file_info',
                opts = {
                    type = 'unique',
                    file_modified_icon = '',
                },
            },
            left_sep = ' ',
            hl = {
                fg = colors.blue,
                style = 'bold',
            },
        },
        encoding = {
            provider = function()
                return vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
            end,
            left_sep = ' ',
            hl = {
                fg = colors.blue,
            },
        },
        type = {
            provider = file_type,
            left_sep = ' ',
            hl = {
                fg = colors.blue,
            },
        },
        position = {
            provider = 'position',
            left_sep = ' ',
            hl = {
                fg = colors.cyan,
            },
        },
    },
    line_percentage = {
        provider = 'line_percentage',
        left_sep = ' ',
        hl = {
            fg = colors.cyan,
        },
    },
    scroll_bar = {
        provider = 'scroll_bar',
        left_sep = ' ',
        right_sep = ' ',
        hl = {
            fg = colors.blue,
        },
    },
    diagnos = {
        err = {
            provider = function()
                return '' .. lsp_get_diag('Error')
            end,
            enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
            end,
            hl = {
                fg = colors.red,
            },
        },
        warn = {
            provider = function()
                return '' .. lsp_get_diag('Warning')
            end,
            enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
            end,
            hl = {
                fg = colors.yellow,
            },
        },
        info = {
            provider = function()
                return '' .. lsp_get_diag('Information')
            end,
            enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
            end,
            hl = {
                fg = colors.blue,
            },
        },
        hint = {
            provider = function()
                return '' .. lsp_get_diag('Hint')
            end,
            enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
            end,
            hl = {
                fg = colors.cyan,
            },
        },
    },
    lsp = {
        name = {
            provider = 'lsp_client_names',
            left_sep = ' ',
            icon = ' ',
            hl = {
                fg = colors.yellow,
            },
        },
    },
    git = {
        branch = {
            provider = 'git_branch',
            icon = ' ',
            left_sep = ' ',
            hl = {
                fg = colors.violet,
                style = 'bold',
            },
        },
        add = {
            provider = 'git_diff_added',
            hl = {
                fg = colors.green,
            },
        },
        change = {
            provider = 'git_diff_changed',
            hl = {
                fg = colors.orange,
            },
        },
        remove = {
            provider = 'git_diff_removed',
            hl = {
                fg = colors.red,
            },
        },
    },
}

local components = {
    active = {},
    inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

table.insert(components.active[1], comps.vi_mode.left)
table.insert(components.active[1], comps.git.branch)
table.insert(components.active[1], comps.git.add)
table.insert(components.active[1], comps.git.change)
table.insert(components.active[1], comps.git.remove)

table.insert(components.active[3], comps.diagnos.err)
table.insert(components.active[3], comps.diagnos.warn)
table.insert(components.active[3], comps.diagnos.hint)
table.insert(components.active[3], comps.diagnos.info)
table.insert(components.active[3], comps.lsp.name)
table.insert(components.active[3], comps.file.type)
table.insert(components.active[3], comps.file.encoding)
table.insert(components.active[3], comps.file.position)
table.insert(components.active[3], comps.vi_mode.right)

table.insert(components.inactive[1], comps.vi_mode.left)
table.insert(components.inactive[1], comps.file.type)

require('feline').setup({
    theme = { bg = colors.bg, fg = colors.fg },
    components = components,
    vi_mode_colors = vi_mode_colors,
    force_inactive = {
        filetypes = {
            'dapui_watches',
            'dapui_stacks',
            'dapui_breakpoints',
            'dapui_scopes',
        },
        buftypes = { 'terminal' },
        bufnames = {},
    },
    disable = {
        filetypes = {
            'man',
            'packer',
            'NvimTree',
            'alpha',
        },
        buftypes = {},
        bufnames = {},
    },
})
