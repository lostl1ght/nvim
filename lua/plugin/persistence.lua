local MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({ source = 'folke/persistence.nvim' })
  require('persistence').setup({ need = 1 })

  local cmd = 'Persistence'
  local commands = {
    load = function() require('persistence').load() end,
    stop = function()
      require('persistence').stop()
      vim.notify('stopped', vim.log.levels.INFO, { title = 'Persistence' })
    end,
    start = function()
      require('persistence').start()
      vim.notify('started', vim.log.levels.INFO, { title = 'Persistence' })
    end,
    select = function() require('persistence').select() end,
    save = function()
      require('persistence').save()
      vim.notify('saved', vim.log.levels.INFO, { title = 'Persistence' })
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
  set('n', 'gss', '<cmd>Persistence load<cr>', { desc = 'Last' })
  set('n', 'gse', '<cmd>Persistence select<cr>', { desc = 'Select' })
  set('n', 'gsa', '<cmd>Persistence save<cr>', { desc = 'Save' })
  set('n', 'gst', '<cmd>Persistence stop<cr>', { desc = 'Stop' })
  set('n', 'gso', '<cmd>Persistence stop<cr>', { desc = 'Start' })
end)
