if vim.g.loaded_keymap_switch then return end
require('keymap_switch').setup({ keymap = 'russian-jcukenwin' })
vim.keymap.set(
  { 'c', 'i', 'n', 's', 'x' },
  '<c-\\>',
  '<plug>(keymap-switch)',
  { desc = 'Switch layout' }
)
vim.g.loaded_keymap_switch = true
