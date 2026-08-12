safely('now', function() require('mini.icons').setup() end)

safely('later', function()
  require('mini.ai').setup()
  require('mini.align').setup()
  require('mini.bracketed').setup({
    diagnostic = { suffix = 'd' },
    comment = { suffix = '' },
    file = { suffix = '' },
    treesitter = { suffix = '' },
    indent = { suffix = '' },
    oldfile = { suffix = '' },
  })

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

  require('ts-comments').setup()
  require('mini.comment').setup({ options = { ignore_blank_line = true } })

  require('mini.move').setup()

  local prefix = 'gs'
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
