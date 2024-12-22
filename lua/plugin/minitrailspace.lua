local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  local option_name = 'autorim_disable'
  add({ source = 'echasnovski/mini.trailspace' })
  require('mini.trailspace').setup({})
  local function toggle(buf)
    vim.b[buf][option_name] = not vim.b[buf][option_name]
    local state = vim.b[buf][option_name] and 'disabled' or 'enabled'
    vim.notify(state, vim.log.levels.INFO, { title = 'Trailspace' })
  end
  local cmd = 'Trim'
  local commands = {
    toggle = function() toggle(0) end,
  }
  vim.api.nvim_create_user_command(cmd, function(data)
    local prefix = require('util').parse(cmd, data.args)
    commands[prefix]()
  end, {
    nargs = 1,
    desc = 'Trim whitespace',
    complete = function(_, line) return require('util').complete(line, cmd, commands) end,
  })
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(data)
      local buf = data.buf
      local enabled = not vim.b[buf][option_name]
      if enabled then
        local minitrailspace = require('mini.trailspace')
        minitrailspace.trim()
        minitrailspace.trim_last_lines()
      end
    end,
    group = vim.api.nvim_create_augroup('TrimWhiteSpace', {}),
    desc = 'Trim trailing whitespace',
  })
  vim.keymap.set('n', '\\t', function() toggle(0) end, { desc = 'Trim whitespace' })
end)
