return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup({
      compile = true,
      undercurl = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          CursorLine = { bg = theme.ui.bg_p1 },
          Folded = { fg = theme.ui.special, bg = theme.ui.bg_m1 },

          LspReferenceRead = { bg = theme.ui.bg_visual },
          LspReferenceText = { bg = theme.ui.bg_visual },
          LspReferenceWrite = { bg = theme.ui.bg_visual, underline = false },

          YankHighlight = { bg = theme.ui.pmenu.bg_sel },

          IncSearch = { bg = theme.vcs.changed, bold = true },
          Substitude = { bg = theme.vcs.removed, bold = true },

          -- NoiceSplit = { link = 'Normal' },
          -- NormalFloat = { link = 'Normal' },
          -- FloatBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
          -- MiniFilesTitle = { fg = theme.ui.special, bg = theme.ui.bg, bold = true },
          -- MiniFilesTitleFocused = { fg = theme.ui.fg, bg = theme.ui.bg, bold = true },

          TelescopeNormal = { link = 'NormalFloat' },
          TelescopeBorder = { link = 'FloatBorder' },

          LightBulbVirtualText = { link = 'Comment' },
        }
      end,
    })
    vim.cmd('colorscheme kanagawa')
  end,
}
