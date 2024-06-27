---@type LazyPluginSpec
return {
  'rebelot/heirline.nvim',

  lazy = false,

  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lostl1ght/keymap-switch.nvim',
    'SmiteshP/nvim-navic',
  },

  config = function()
    local statusline = require('plugins.heirline.statusline').StatusLine
    local winbar = require('plugins.heirline.winbar').WinBar
    local tabline = require('plugins.heirline.tabline').TabLine
    local utils = require('heirline.utils')

    local function setup_colors()
      local colors = {
        bg = utils.get_highlight('Normal').bg or 'NONE',
        white = utils.get_highlight('Cursor').bg,
        black = utils.get_highlight('Cursor').fg,
        gray = utils.get_highlight('Comment').fg,
        green = utils.get_highlight('DiagnosticOk').fg,
        teal = utils.get_highlight('DiagnosticHint').fg,
        blue = utils.get_highlight('DiagnosticInfo').fg,
        yellow = utils.get_highlight('DiagnosticWarn').fg,
        red = utils.get_highlight('DiagnosticError').fg,
      }
      if vim.g.colors_name == 'rose-pine' then
        local palette = require('rose-pine.palette')
        colors.black = palette.base
        colors.white = palette.text
      end

      return colors
    end

    require('heirline').setup({
      statusline = statusline,
      winbar = winbar,
      tabline = tabline,
      opts = {
        disable_winbar_cb = function(args)
          return require('heirline.conditions').buffer_matches({
            buftype = { 'prompt', 'nofile', 'quickfix' },
            filetype = { 'lazygit', 'trouble' },
          }, args.buf)
        end,
        colors = setup_colors(),
      },
    })

    local aug = vim.api.nvim_create_augroup('HeirlineColors', {})
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = aug,
    })
  end,
}
