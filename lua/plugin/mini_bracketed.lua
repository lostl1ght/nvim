local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.bracketed' })
  require('mini.bracketed').setup({
    diagnostic = { suffix = 'd', options = { float = false } },
    comment = { suffix = '' },
    file = { suffix = '' },
    treesitter = { suffix = '' },
    indent = { suffix = '' },
    oldfile = { suffix = '' },
  })
end)
