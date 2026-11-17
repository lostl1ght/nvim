safely('now', function()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active
      if kind == 'update' or kind == 'install' then
        if name == 'nvim-treesitter' then
          if not active then vim.cmd.packadd('nvim-treesitter') end
          vim.cmd('TSUpdate')
        end
      end
    end,
    desc = 'Update treesitter'
  })
  -- TSInstall bash c lua luadoc luap markdown markdown_inline query regex vim vimdoc gitattributes gitcommit gitignore git_config git_rebase json toml yaml go gomod gosum gowork python rust make
  vim.pack.add({ gh('nvim-treesitter/nvim-treesitter') }, { confirm = false })
end)

safely('now', function()
  vim.pack.add({ gh('HiPhish/rainbow-delimiters.nvim') }, { confirm = false })

  local cmd = 'Rainbow'
  local commands = {
    toggle = function() require('rainbow-delimiters').toggle(0) end,
    disable = function() require('rainbow-delimiters').disable(0) end,
    enable = function() require('rainbow-delimiters').enable(0) end,
  }
  vim.api.nvim_create_user_command(cmd, function(data)
    local prefix = require('util').parse(cmd, data.args)
    commands[prefix]()
  end, {
    nargs = 1,
    desc = 'Rainbow delimiters',
    complete = function(_, line) return require('util').complete(line, cmd, commands) end,
  })
  local rd = require('rainbow-delimiters')
  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = rd.strategy['global'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      ['latex'] = 'rainbow-delimiters',
    },
    priority = {
      [''] = 250,
    },
  }
end)

safely('later', function()
  vim.pack.add({ gh('m-demare/hlargs.nvim') }, { confirm = false })
  require('hlargs').setup({
    excluded_argnames = {
      usages = {
        python = {},
        lua = {},
      },
    },
  })
end)

safely('later', function()
  vim.pack.add({ gh('nvim-treesitter/nvim-treesitter-context') }, { confirm = false })
  vim.keymap.set('n', '\\c', function()
    local tsc = require('treesitter-context')
    tsc.toggle()
    vim.notify((tsc.enabled() and '' or 'no') .. 'context')
  end, { desc = 'Context' })
end)
