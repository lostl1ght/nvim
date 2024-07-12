local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add({ source = 'lostl1ght/lazygit.nvim', depends = { 'samjwill/nvim-unception' } })
  vim.keymap.set('n', 'gl', '<cmd>Lazygit<cr>', { desc = 'Lazygit' })
end)
