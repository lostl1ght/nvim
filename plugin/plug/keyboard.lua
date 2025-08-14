local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'kawre/neotab.nvim' })
  require('neotab').setup({
    pairs = {
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '<', close = '>' },
      { open = '$', close = '$' },
    },
  })
end)

later(function()
  require('keymap_switch').setup({ keymap = 'russian-jcukenwin' })
  vim.keymap.set(
    { 'c', 'i', 'n', 's', 'x' },
    '<c-\\>',
    '<plug>(keymap-switch)',
    { desc = 'Switch layout' }
  )
end)
