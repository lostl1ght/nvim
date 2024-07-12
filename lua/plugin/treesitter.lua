local MiniDeps = require('mini.deps')
local add, now = MiniDeps.add, MiniDeps.now
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
