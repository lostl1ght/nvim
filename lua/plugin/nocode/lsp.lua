local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = {
      post_install = function() vim.cmd('MasonUpdate') end,
      post_checkout = function() vim.cmd('MasonUpdate') end,
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

now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'pmizio/typescript-tools.nvim',
      'nvim-lua/plenary.nvim',
      'saghen/blink.cmp',
    },
  })
  require('mason-lspconfig').setup({ automatic_enable = { exclude = { 'ruff' } } })

  require('typescript-tools').setup({})
end)

now(function()
  add({ source = 'folke/lazydev.nvim', depends = { 'Bilal2453/luvit-meta' } })
  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'Lazy%a' } },
    },
  })
end)

now(function() require('lightbulb').setup_au() end)
