local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'echasnovski/mini.trailspace' })
  require('mini.trailspace').setup({})
  local function toggle(buf)
    vim.b[buf].minitrailspace_disable = not vim.b[buf].minitrailspace_disable
    require('mini.trailspace').highlight()
    local state = vim.b.minitrailspace_disable and 'disabled' or 'enabled'
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
      local enabled = not vim.b[buf].minitrailspace_disable
      if enabled then
        local MiniTrailspace = MiniTrailspace or require('mini.trailspace')
        MiniTrailspace.trim()
      end
    end,
    group = vim.api.nvim_create_augroup('TrimWhiteSpace', {}),
    desc = 'Trim trailing whitespace',
  })
end)
