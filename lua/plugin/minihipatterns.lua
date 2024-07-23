local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.hipatterns' })
  local cmd = 'Hipatterns'
  local commands = {
    enable = function() require('mini.hipatterns').enable() end,
    disable = function() require('mini.hipatterns').disable() end,
    update = function() require('mini.hipatterns').update() end,
    toggle = function() require('mini.hipatterns').toggle() end,
  }

  vim.api.nvim_create_user_command(cmd, function(data)
    local prefix = require('util').parse(cmd, data.args)
    commands[prefix]()
  end, {
    nargs = 1,
    desc = 'Hipatterns',
    complete = function(_, line) return require('util').complete(line, cmd, commands) end,
  })

  local minihipatterns = require('mini.hipatterns')
  minihipatterns.setup({
    highlighters = {
      hex_color = minihipatterns.gen_highlighter.hex_color({
        style = 'inline',
        inline_text = '⬤ ',
        priority = 2000,
      }),
    },
  })
end)
