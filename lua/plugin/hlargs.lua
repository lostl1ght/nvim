local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'm-demare/hlargs.nvim' })
  require('hlargs').setup({
    excluded_argnames = {
      usages = {
        python = {},
        lua = {},
      },
    },
  })
end)
