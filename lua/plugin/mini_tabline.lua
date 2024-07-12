local MiniDeps = require('mini.deps')
local add, now = MiniDeps.add, MiniDeps.now
now(function()
  add({ source = 'echasnovski/mini.tabline', depends = { 'echasnovski/mini.icons' } })
  require('mini.tabline').setup()
end)
