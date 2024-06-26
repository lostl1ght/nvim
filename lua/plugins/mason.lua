---@type LazyPluginSpec
return {
  'williamboman/mason.nvim',
  cmd = 'Mason',
  build = ':MasonUpdate',
  keys = {
    {
      '<leader>pm',
      function()
        vim.cmd({ cmd = 'Mason' })
      end,
      desc = 'Mason',
    },
  },
  config = function()
    require('mason').setup({
      ui = {
        border = 'single',
        width = 0.8,
        height = 0.8,
      },
    })
  end,
}
