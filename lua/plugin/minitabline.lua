local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'echasnovski/mini.tabline', depends = { 'echasnovski/mini.icons' } })
  require('mini.tabline').setup()
end)
