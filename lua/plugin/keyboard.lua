local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'kawre/neotab.nvim' })
  require('neotab').setup({
    pairs = {
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '<', close = '>' },
      { open = '$', close = '$' },
    },
  })
end)
