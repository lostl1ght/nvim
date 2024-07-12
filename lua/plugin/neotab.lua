local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add({ source = 'kawre/neotab.nvim' })
  require('neotab').setup({ act_as_tab = false })
end)
