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
        FlashPrompt = { fg = theme.ui.special, bg = theme.ui.bg, bold = true },
        FloatTitle = { fg = theme.ui.special, bg = theme.ui.bg, bold = true },
        FloatBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
        MsgArea = { link = 'Normal' },
        NormalFloat = { link = 'Normal' },
        MiniFilesTitle = { link = 'FloatTitle' },
        MiniFilesTitleFocused = { fg = palette.oniViolet2, bg = theme.ui.bg, bold = true },
        MiniPickPrompt = { link = 'FloatTitle' },
        -- NOTE: end

        LightBulbVirtualText = { link = 'Comment' },

        MiniTrailspace = { fg = theme.diag.error, bg = 'none' },

        IblIndent = { fg = theme.ui.bg_p2 },
        IblWhitespace = { fg = theme.ui.bg_p2 },
        IblScope = { fg = theme.ui.whitespace },

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

        MiniTablineHidden = { fg = theme.ui.special, bg = theme.ui.bg_m3, italic = true },
        MiniTablineModifiedHidden = { fg = theme.ui.bg_m3, bg = theme.ui.special, italic = true },

        MiniStatuslinePath = { fg = theme.syn.comment, bg = theme.ui.bg_dim },

        MiniJump = { sp = theme.diag.error, undercurl = true, bold = true },
      }
      local kinds = {
        'Class',
        'Color',
        'Constant',
        'Constructor',
        'Enum',
        'EnumMember',
        'Event',
        'Field',
        'File',
        'Folder',
        'Function',
        'Interface',
        'Keyword',
        'Method',
        'Module',
        'Operator',
        'Property',
        'Reference',
        'Snippet',
        'Struct',
        'Text',
        'TypeParameter',
        'Unit',
        'Value',
        'Variable',
      }
      local cmp_fg = palette.sumiInk0
      local miniicons = require('mini.icons')
      local function cmp_bg(kind)
        local cmp_hl = select(2, miniicons.get('lsp', kind))
        return vim.api.nvim_get_hl(0, { name = cmp_hl }).fg
      end
      for _, kind in ipairs(kinds) do
        hl['CmpItemKind' .. kind] = { fg = cmp_fg, bg = cmp_bg(kind) }
      end
      return hl
    end,
  })
  vim.cmd('colorscheme kanagawa')
end)
