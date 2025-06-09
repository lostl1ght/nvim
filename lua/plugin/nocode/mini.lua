local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  add({ source = 'echasnovski/mini.icons' })
  require('mini.icons').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.move' })
  require('mini.move').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.align' })
  require('mini.align').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.bracketed' })
  require('mini.bracketed').setup({
    diagnostic = { suffix = 'd' },
    comment = { suffix = '' },
    file = { suffix = '' },
    treesitter = { suffix = '' },
    indent = { suffix = '' },
    oldfile = { suffix = '' },
  })
end)

later(function()
  add({ source = 'folke/ts-comments.nvim' })
  require('ts-comments').setup()
end)

later(function()
  add({ source = 'echasnovski/mini.bufremove' })
  require('mini.bufremove').setup()
  vim.api.nvim_create_user_command('Bdelete', function(data)
    local name = vim.fn.bufname(vim.fn.expand(data.args))
    local buf_id = vim.fn.bufnr(name)
    require('mini.bufremove').delete(buf_id)
  end, { nargs = '?', desc = 'Mini bdelete', bang = true, complete = 'buffer' })
  vim.api.nvim_create_user_command('Bunshow', function(data)
    local name = vim.fn.bufname(vim.fn.expand(data.args))
    local buf_id = vim.fn.bufnr(name)
    require('mini.bufremove').unshow(buf_id)
  end, { nargs = '?', desc = 'Mini bunshow', complete = 'buffer' })
end)
