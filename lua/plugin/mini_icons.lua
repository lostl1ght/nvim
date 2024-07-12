local MiniDeps = require('mini.deps')
local add, now = MiniDeps.add, MiniDeps.now
now(function()
  add({ source = 'echasnovski/mini.icons' })
  require('mini.icons').setup({ filetype = { lazygit = { glyph = '󰊢' } } })
end)
