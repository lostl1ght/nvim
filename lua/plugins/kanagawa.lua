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
        local palette = colors.palette

        local cmp = {
          fg = palette.sumiInk0,
          cyan = palette.waveAqua2,
          yellow = palette.carpYellow,
          gray = palette.oldWhite,
          blue = palette.crystalBlue,
          magenta = palette.oniViolet,
          orange = palette.surimiOrange,
          green = palette.springGreen,
        }

        return {
          CursorLine = { bg = theme.ui.bg_p1 },
          CursorLineNr = { fg = theme.vcs.changed, bold = false },
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

          MiniTrailspace = { fg = theme.diag.error, bg = theme.diff.delete },

          CmpItemKindKeyword = { fg = cmp.fg, bg = cmp.cyan },

          CmpItemKindModule = { fg = cmp.fg, bg = cmp.yellow },
          CmpItemKindSnippet = { fg = cmp.fg, bg = cmp.gray },

          CmpItemKindConstructor = { fg = cmp.fg, bg = cmp.blue },
          CmpItemKindFunction = { fg = cmp.fg, bg = cmp.blue },
          CmpItemKindMethod = { fg = cmp.fg, bg = cmp.blue },

          CmpItemKindConstant = { fg = cmp.fg, bg = cmp.magenta },
          CmpItemKindReference = { fg = cmp.fg, bg = cmp.magenta },
          CmpItemKindVariable = { fg = cmp.fg, bg = cmp.magenta },
          CmpItemKindValue = { fg = cmp.fg, bg = cmp.magenta },

          CmpItemKindText = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindEnum = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindStruct = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindClass = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindFile = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindUnit = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindFolder = { fg = cmp.fg, bg = cmp.orange },
          CmpItemKindInterface = { fg = cmp.fg, bg = cmp.orange },

          CmpItemKindField = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindProperty = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindEvent = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindOperator = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindEnumMember = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindColor = { fg = cmp.fg, bg = cmp.green },
          CmpItemKindTypeParameter = { fg = cmp.fg, bg = cmp.green },

          IblIndent = { fg = theme.ui.bg_p2 },
          IblWhitespace = { fg = theme.ui.bg_p2 },
          IblScope = { fg = theme.ui.whitespace },

          Hlargs = { fg = palette.lightBlue },
        }
      end,
    })
    vim.cmd('colorscheme kanagawa')
  end,
}
