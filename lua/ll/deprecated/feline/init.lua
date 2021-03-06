if not pcall(require, 'feline') then
    return print('feline not found')
end

vim.o.termguicolors = true
vim.o.showmode = false

local colors = require('ll.color.feline.' .. llvim.style)

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

local osinfo = function()
    return vim.bo.fileformat
end

local osicon = function()
    local os = osinfo()
    if os == 'unix' then
        return ' '
    elseif os == 'mac' then
        return ' '
    else
        return ' '
    end
end

local filetype = function()
    local name = vim.fn.expand('%:t')
    local ext = vim.fn.expand('%:e')
    local icon, _ = require('nvim-web-devicons').get_icon(name, ext, { default = true })
    return icon .. ' ' .. vim.bo.filetype
end

local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local lsp_get_diag = function(str)
    local count = vim.lsp.diagnostic.get_count(0, str)
    return (count > 0) and ' ' .. count .. ' ' or ''
end

local comps = {
    vi_mode = {
        left = {
            provider = function()
                -- return '  ' .. vi_mode_utils.get_vim_mode()
                return ' ' .. osicon() .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color(),
                    style = 'bold',
                }
                return val
            end,
        },
        right = {
            provider = '',
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color(),
                }
                return val
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
            provider = 'file_encoding',
            left_sep = ' ',
            hl = {
                fg = colors.violet,
                style = 'bold',
            },
        },
        type = {
            provider = filetype,
            left_sep = ' ',
            hl = {
                fg = colors.blue,
            },
        },
        os = {
            provider = osinfo,
            left_sep = ' ',
            hl = {
                fg = colors.violet,
                style = 'bold',
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
    left_end = {
        provider = function()
            return ''
        end,
        hl = {
            fg = colors.bg,
            bg = colors.blue,
        },
    },
    line_percentage = {
        provider = 'line_percentage',
        left_sep = ' ',
        hl = {
            style = 'bold',
        },
    },
    scroll_bar = {
        provider = 'scroll_bar',
        left_sep = ' ',
        hl = {
            fg = colors.blue,
            style = 'bold',
        },
    },
    diagnos = {
        err = {
            -- provider = 'diagnostic_errors',
            provider = function()
                return '' .. lsp_get_diag('Error')
            end,
            -- left_sep = ' ',
            enabled = function()
                return lsp.diagnostics_exist('Error')
            end,
            hl = {
                fg = colors.red,
            },
        },
        warn = {
            -- provider = 'diagnostic_warnings',
            provider = function()
                return '' .. lsp_get_diag('Warning')
            end,
            -- left_sep = ' ',
            enabled = function()
                return lsp.diagnostics_exist('Warning')
            end,
            hl = {
                fg = colors.yellow,
            },
        },
        info = {
            -- provider = 'diagnostic_info',
            provider = function()
                return '' .. lsp_get_diag('Information')
            end,
            -- left_sep = ' ',
            enabled = function()
                return lsp.diagnostics_exist('Information')
            end,
            hl = {
                fg = colors.blue,
            },
        },
        hint = {
            -- provider = 'diagnostic_hints',
            provider = function()
                return '' .. lsp_get_diag('Hint')
            end,
            -- left_sep = ' ',
            enabled = function()
                return lsp.diagnostics_exist('Hint')
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
            icon = ' ',
            hl = {
                fg = colors.yellow,
            },
        },
    },
    git = {
        branch = {
            provider = 'git_branch',
            icon = ' ',
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
table.insert(components.active[3], comps.file.position)
table.insert(components.active[3], comps.line_percentage)
table.insert(components.active[3], comps.scroll_bar)
table.insert(components.active[3], comps.vi_mode.right)

table.insert(components.inactive[1], comps.vi_mode.left)
table.insert(components.inactive[1], comps.file.type)

-- TreeSitter
-- local ts_utils = require('nvim-treesitter.ts_utils')
-- local ts_parsers = require('nvim-treesitter.parsers')
-- local ts_queries = require('nvim-treesitter.query')
--[[ table.insert(components.active[2], {
  provider = function()
    local node = require('nvim-treesitter.ts_utils').get_node_at_cursor()
    return ('%d:%s [%d, %d] - [%d, %d]')
      :format(node:symbol(), node:type(), node:range())
  end,
  enabled = function()
    local ok, ts_parsers = pcall(require, 'nvim-treesitter.parsers')
    return ok and ts_parsers.has_parser()
  end
}) --]]

require('feline').setup({
    colors = { bg = colors.bg, fg = colors.fg },
    components = components,
    vi_mode_colors = vi_mode_colors,
    force_inactive = {
        filetypes = {
            'man',
            'packer',
            'NvimTree',
            'alpha',
        },
        buftypes = { 'terminal' },
        bufnames = {},
    },
    disable = {
        filetypes = {},
        buftypes = {},
        bufnames = {},
    },
})
