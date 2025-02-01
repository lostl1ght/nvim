local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'rebelot/kanagawa.nvim', depends = { 'echasnovski/mini.icons' } })
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

      local hl = {
        CursorLine = { bg = theme.ui.bg_p1 },
        CursorLineNr = { fg = palette.boatYellow1 },
        Folded = { fg = theme.ui.special, bg = theme.ui.bg_m1 },

        LspReferenceRead = { bg = theme.ui.bg_visual },
        LspReferenceText = { bg = theme.ui.bg_visual },
        LspReferenceWrite = { bg = theme.ui.bg_visual, underline = false },

        YankHighlight = { bg = theme.ui.pmenu.bg_sel },

        IncSearch = { bg = theme.vcs.changed, bold = true },
        Substitude = { bg = theme.vcs.removed, bold = true },

        -- NOTE: blend float with normal
        --[[
        FloatTitle = { fg = theme.ui.special, bg = theme.ui.bg, bold = true },
        FloatBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
        MsgArea = { link = 'Normal' },
        NormalFloat = { link = 'Normal' },
        MiniPickPrompt = { link = 'FloatTitle' },
        ]]
        -- NOTE: end
        MiniFilesTitle = { link = 'FloatTitle' },
        MiniFilesTitleFocused = { fg = palette.oniViolet2, bg = theme.ui.bg, bold = true },

        NoiceCmdLine = { link = 'StatusLine' },

        LightBulbVirtualText = { link = 'Comment' },

        MiniTrailspace = { fg = theme.diag.error, bg = 'none' },

        SnacksIndent = { fg = theme.ui.bg_p2 },
        SnacksIndentScope = { fg = theme.ui.whitespace },

        Hlargs = { link = '@variable.parameter' },

        RainbowDelimiterRed = { fg = palette.lotusRed2 },
        RainbowDelimiterYellow = { fg = palette.lotusYellow3 },
        RainbowDelimiterBlue = { fg = palette.lotusBlue4 },
        RainbowDelimiterOrange = { fg = palette.lotusOrange },
        RainbowDelimiterGreen = { fg = palette.lotusGreen2 },
        RainbowDelimiterViolet = { fg = palette.lotusViolet2 },
        RainbowDelimiterCyan = { fg = palette.lotusTeal1 },

        LspInfoBorder = { link = 'FloatBorder' },

        TroublePreview = { bg = theme.ui.pmenu.bg_sel },

        TreesitterContext = { fg = theme.ui.special, bg = theme.ui.bg_m1 },
        TreesitterContextLineNumber = { fg = theme.ui.special, bg = theme.ui.bg_m1 },

        FlashPrompt = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
        FlashLabel = {
          fg = palette.sumiInk0,
          bg = palette.lotusGray3,
          bold = true,
          nocombine = true,
        },
        FlashMatch = { fg = palette.lotusGreen, nocombine = true },
        FlashCurrent = { fg = palette.waveAqua1, nocombine = true },
        FlashBackdrop = { fg = palette.boatYellow1 },

        BlinkCmpMenu = { link = 'NormalFloat' },
        BlinkCmpMenuSelection = { link = 'Visual' },
      }
      return hl
    end,
  })
  vim.cmd('colorscheme kanagawa')
end)
