local MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({ source = 'echasnovski/mini.icons' })
  require('mini.icons').setup({ filetype = { lazygit = { glyph = '󰊢' } } })
end)

later(function()
  add({ source = 'echasnovski/mini.ai' })
  require('mini.ai').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.align' })
  require('mini.align').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.bracketed' })
  require('mini.bracketed').setup({
    diagnostic = { suffix = 'd', options = { float = false } },
    comment = { suffix = '' },
    file = { suffix = '' },
    treesitter = { suffix = '' },
    indent = { suffix = '' },
    oldfile = { suffix = '' },
  })
end)

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

later(function()
  add({ source = 'echasnovski/mini.comment', depends = { 'folke/ts-comments.nvim' } })
  require('ts-comments').setup()
  require('mini.comment').setup({ options = { ignore_blank_line = true } })
end)

later(function()
  add({ source = 'echasnovski/mini.move' })
  require('mini.move').setup()
end)

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
