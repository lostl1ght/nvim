local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'kawre/neotab.nvim' })
  require('neotab').setup({ act_as_tab = false })
end)
