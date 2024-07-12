local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'lostl1ght/lightbulb.nvim' })
  require('lightbulb').setup({ virtual_text = { spacing = 1 } })
end)
