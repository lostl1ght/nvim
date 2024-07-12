local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.ai' })
  require('mini.ai').setup()
end)
