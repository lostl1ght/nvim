local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.surround' })
  require('mini.surround').setup({
    mappings = {
      add = 'ma',
      delete = 'md',
      find = 'mf',
      find_left = 'mF',
      highlight = 'mh',
      replace = 'mr',
      update_n_lines = 'mn',

      suffix_last = 'l',
      suffix_next = 'n',
    },
  })
end)
