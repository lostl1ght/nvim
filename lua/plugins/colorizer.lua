return {
  'NvChad/nvim-colorizer.lua',

  cmd = 'ColorizerToggle',

  keys = {
    {
      '<leader>tr',
      function()
        vim.cmd({ cmd = 'ColorizerToggle' })
      end,
      desc = 'Colorizer',
    },
  },

  config = function()
    require('colorizer').setup({
      filetypes = { '*' },
      user_default_options = {
        RGB = false,
        RRGGBB = true,
        names = false,
      },
    })
  end,
}
