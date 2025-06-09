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
  set('n', 'gS', '<cmd>Persistence load<cr>', { desc = 'Load session' })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistenceLoadPre',
    command = '%bdelete',
  })
end)
