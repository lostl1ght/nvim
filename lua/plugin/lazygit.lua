local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  add({ source = 'willothy/flatten.nvim' })
  require('flatten').setup({
    window = { open = 'smart' },
    callbacks = {
      pre_open = vim.schedule_wrap(function() require('lazygit').hide() end),
      block_end = vim.schedule_wrap(function() require('lazygit').show() end),
    },
  })
end)

later(function()
  add({ source = 'lostl1ght/lazygit.nvim' })
  vim.keymap.set('n', '<leader>g', '<cmd>Lazygit<cr>', { desc = 'Lazygit' })
end)
