return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup({
      highlight_groups = {
        YankHighlight = { bg = 'highlight_high' },
        LightBulbVirtualText = { link = 'Comment' },
        Folded = { bg = 'surface' },
      },
    })
    vim.cmd('colorscheme rose-pine')
  end,
}
