local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

later(function()
  add({ source = 'folke/persistence.nvim' })
  require('persistence').setup({ need = 1 })

  local cmd = 'Persistence'
  local commands = {
    load = function() require('persistence').load() end,
    stop = function()
      require('persistence').stop()
      vim.notify('Persistence stopped', vim.log.levels.INFO)
    end,
    start = function()
      require('persistence').start()
      vim.notify('Persistence started', vim.log.levels.INFO)
    end,
    select = function() require('persistence').select() end,
    save = function()
      require('persistence').save()
      vim.notify('Session saved', vim.log.levels.INFO)
    end,
  }
  vim.api.nvim_create_user_command(cmd, function(data)
    local prefix = require('util').parse(cmd, data.args)
    commands[prefix]()
  end, {
    nargs = 1,
    desc = 'Persistence',
    complete = function(_, line) return require('util').complete(line, cmd, commands) end,
  })
end)

now(function()
  local set = vim.keymap.set
  set('n', '<leader>ss', '<cmd>Persistence load<cr>', { desc = 'Last' })
  set('n', '<leader>se', '<cmd>Persistence select<cr>', { desc = 'Select' })
  set('n', '<leader>sa', '<cmd>Persistence save<cr>', { desc = 'Save' })
  set('n', '<leader>st', '<cmd>Persistence stop<cr>', { desc = 'Stop' })
  set('n', '<leader>so', '<cmd>Persistence stop<cr>', { desc = 'Start' })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistenceLoadPre',
    command = '%bdelete',
  })
end)
