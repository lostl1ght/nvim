local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'stevearc/dressing.nvim' })
  require('dressing').setup({
    input = { relative = 'editor', border = vim.g.border },
    select = { enabled = false },
  })
end)
