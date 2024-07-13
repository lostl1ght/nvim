local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    monitor = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })
  require('nvim-treesitter').setup({
    ensure_install = {
      'bash',
      'c',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'query',
      'regex',
      'vim',
      'vimdoc',

      'gitattributes',
      -- 'gitcommit',
      'gitignore',
      'git_config',
      'git_rebase',
      'json',
      'toml',
      'yaml',
    },
  })
end)

now(function()
  add({ source = 'HiPhish/rainbow-delimiters.nvim' })
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
end)

later(function()
  add({ source = 'm-demare/hlargs.nvim' })
  require('hlargs').setup({
    excluded_argnames = {
      usages = {
        python = {},
        lua = {},
      },
    },
  })
end)

later(function()
  add({ source = 'nvim-treesitter/nvim-treesitter-context' })
  vim.keymap.set('n', '\\c', function()
    local tsc = require('treesitter-context')
    tsc.toggle()
    print((tsc.enabled() and '' or 'no') .. 'context')
  end, { desc = 'Context' })
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
