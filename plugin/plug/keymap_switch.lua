local minideps = require('mini.deps')
local later = minideps.later

later(function()
  require('keymap_switch').setup({ keymap = 'russian-jcukenwin' })
  vim.keymap.set(
    { 'c', 'i', 'n', 's', 'x' },
    '<c-\\>',
    '<plug>(keymap-switch)',
    { desc = 'Switch layout' }
  )
end)
