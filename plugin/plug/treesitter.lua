local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() require('nvim-treesitter').update(nil, { summary = true }) end,
    },
  })
  --stylua: ignore
  require('nvim-treesitter').install({
    'bash', 'c', 'lua', 'luadoc', 'luap',
    'markdown', 'markdown_inline', 'query',
    'regex', 'vim', 'vimdoc',

    'gitattributes', 'gitcommit', 'gitignore',
    'git_config', 'git_rebase', 'json', 'toml',
    'yaml',

    'go', 'gomod', 'gosum', 'gowork',
    'python', 'rust',
  }, { summary = false })
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
    vim.notify((tsc.enabled() and '' or 'no') .. 'context')
  end, { desc = 'Context' })
end)
