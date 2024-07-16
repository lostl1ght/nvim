local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.jump2d' })
  require('mini.jump2d').setup({
    view = {
      dim = true,
    },
    mappings = {
      start_jumping = 's',
    },
    silent = true,
  })
end)

later(function()
  add({ source = 'echasnovski/mini.jump' })
  require('mini.jump').setup()
end)
