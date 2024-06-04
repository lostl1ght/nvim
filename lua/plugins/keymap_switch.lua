return {
  'lostl1ght/keymap-switch.nvim',
  keys = {
    { '<c-\\>', '<plug>(keymap-switch)', mode = { 'i', 'c', 'n' } },
  },
  config = function()
    require('keymap_switch').setup({ keymap = 'russian-jcukenwin', format = string.upper })
  end,
}
