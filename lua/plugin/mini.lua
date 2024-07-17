local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  add({ source = 'echasnovski/mini.icons' })
  require('mini.icons').setup()
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
  vim.api.nvim_create_user_command('Bdelete', function(data)
    local name = vim.fn.bufname(data.args)
    local buf_id = vim.fn.bufnr(name)
    require('mini.bufremove').delete(buf_id)
  end, { nargs = '*', desc = 'Mini bufremove delete', bang = true, complete = 'buffer' })
  vim.api.nvim_create_user_command(
    'Bunshow',
    function() require('mini.bufremove').unshow() end,
    { nargs = '?', desc = 'Mini bufremove delete' }
  )
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
