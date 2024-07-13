local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'stevearc/dressing.nvim' })
  require('dressing').setup({
    input = { relative = 'editor', border = vim.g.border },
    select = { enabled = false },
  })
end)
