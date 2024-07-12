local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
      post_install = function() vim.cmd('MasonUpdate') end,
    },
  })
  require('mason').setup({
    ui = {
      border = vim.g.border,
      width = 0.8,
      height = 0.8,
    },
  })
end)
