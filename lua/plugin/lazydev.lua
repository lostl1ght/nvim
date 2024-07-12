local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'folke/lazydev.nvim', depends = { 'Bilal2453/luvit-meta' } })
  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'Lazy%a' } },
    },
  })
end)
