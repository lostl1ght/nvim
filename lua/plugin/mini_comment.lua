local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.comment', depends = { 'folke/ts-comments.nvim' } })
  require('ts-comments').setup()
  require('mini.comment').setup({ options = { ignore_blank_line = true } })
end)
