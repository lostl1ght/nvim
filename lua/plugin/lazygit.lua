local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'lostl1ght/lazygit.nvim' })
  vim.keymap.set('n', '<leader>g', '<cmd>Lazygit<cr>', { desc = 'Lazygit' })
end)
