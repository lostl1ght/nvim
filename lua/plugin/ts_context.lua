local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'nvim-treesitter/nvim-treesitter-context' })
  vim.keymap.set('n', 'grc', '<cmd>Context toggle<cr>', { desc = 'Context' })
  local cmd = 'Context'
  local commands = {
    toggle = function() require('treesitter-context').toggle() end,
    disable = function() require('treesitter-context').disable() end,
    enable = function() require('treesitter-context').enable() end,
  }
  vim.api.nvim_create_user_command(cmd, function(data)
    local prefix = require('util').parse(cmd, data.args)
    commands[prefix]()
  end, {
    nargs = 1,
    desc = 'Treesitter context',
    complete = function(_, line) return require('util').complete(line, cmd, commands) end,
  })
  require('treesitter-context').setup({ enable = false })
  vim.api.nvim_del_user_command('TSContextEnable')
  vim.api.nvim_del_user_command('TSContextDisable')
  vim.api.nvim_del_user_command('TSContextToggle')
end)
