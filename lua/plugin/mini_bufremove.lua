local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.bufremove' })
  require('mini.bufremove').setup()
  local set = vim.keymap.set
  set('n', 'gbd', function() require('mini.bufremove').delete() end, { desc = 'Delete' })
  set('n', 'gbD', function() require('mini.bufremove').delete(nil, true) end, {
    desc = 'Force delete',
  })
  set('n', 'gbu', function() require('mini.bufremove').unshow() end, { desc = 'Unshow' })
end)
