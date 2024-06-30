---@type LazyPluginSpec
return {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'Rainbow',
  config = function()
    local rd = require('rainbow-delimiters')
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rd.strategy['global'], -- https://github.com/HiPhish/rainbow-delimiters.nvim/issues/2
        -- [''] = rd.strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        latex = 'rainbow-blocks',
      },
      priority = {
        [''] = 250,
      },
    }

    local cmd = 'Rainbow'
    local commands = {
      toggle = function()
        require('rainbow-delimiters').toggle(0)
      end,
      disable = function()
        require('rainbow-delimiters').disable(0)
      end,
      enable = function()
        require('rainbow-delimiters').enable(0)
      end,
    }
    vim.api.nvim_create_user_command(cmd, function(data)
      local prefix = require('util').parse(cmd, data.args)
      commands[prefix]()
    end, {
      nargs = 1,
      desc = 'Rainbow delimiters',
      complete = function(_, line)
        return require('util').complete(line, cmd, commands)
      end,
    })
  end,
}
