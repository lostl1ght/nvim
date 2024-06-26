---@type LazyPluginSpec
return {
  'NvChad/nvim-colorizer.lua',
  init = function()
    vim.g.loaded_colorizer = true
  end,
  cmd = 'Colorizer',
  config = function()
    require('colorizer').setup({
      filetypes = { '*' },
      user_default_options = {
        RGB = false,
        RRGGBB = true,
        names = false,
      },
    })

    local cmd = 'Colorizer'
    local commands = {
      toggle = function()
        local c = require('colorizer')
        if c.is_buffer_attached(0) then
          c.detach_from_buffer(0)
        else
          c.attach_to_buffer(0)
        end
      end,
      reload = function()
        require('colorizer').reload_all_buffers()
      end,
      attach = function()
        require('colorizer').attach_to_buffer(0)
      end,
      detach = function()
        require('colorizer').detach_from_buffer(0)
      end,
    }
    vim.api.nvim_create_user_command(cmd, function(data)
      local prefix = require('util').parse(cmd, data.args)
      commands[prefix]()
    end, {
      nargs = 1,
      desc = 'Colorizer',
      complete = function(_, line)
        return require('util').complete(line, cmd, commands)
      end,
    })
  end,
}
