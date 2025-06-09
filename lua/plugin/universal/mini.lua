local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.ai' })
  require('mini.ai').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.comment' })
  require('mini.comment').setup({ options = { ignore_blank_line = true } })
end)

later(function()
  add({ source = 'echasnovski/mini.surround' })
  local prefix = 's'
  require('mini.surround').setup({
    mappings = {
      add = prefix .. 'a',
      delete = prefix .. 'd',
      find = prefix .. 'f',
      find_left = prefix .. 'F',
      highlight = prefix .. 'h',
      replace = prefix .. 'r',
      update_n_lines = prefix .. 'n',

      suffix_last = 'l',
      suffix_next = 'n',
    },
  })
end)
