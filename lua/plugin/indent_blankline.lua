local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'lukas-reineke/indent-blankline.nvim' })
  require('ibl').setup({
    indent = { char = '│' },
    scope = { enabled = true, show_start = false, show_end = false },
  })
end)

