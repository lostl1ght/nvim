local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

now(function()
  -- add({ source = 'willothy/flatten.nvim' })
  add({ source = 'lostl1ght/flatten.nvim', checkout = 'develop' })
  require('flatten').setup({
    window = { open = 'smart' },
    callbacks = {
      pre_open = vim.schedule_wrap(function() require('lazygit').hide() end),
      post_open = function(buf_id)
        if vim.list_contains({ 'gitcommit', 'gitrebase' }, vim.bo[buf_id].filetype) then
          vim.api.nvim_create_autocmd('BufWritePost', {
            buffer = buf_id,
            once = true,
            callback = vim.schedule_wrap(function() require('mini.bufremove').delete(buf_id) end),
          })
        end
      end,
      block_end = vim.schedule_wrap(function() require('lazygit').show() end),
    },
  })
end)

later(function()
  add({ source = 'lostl1ght/lazygit.nvim' })
  vim.keymap.set('n', '<leader>g', '<cmd>Lazygit<cr>', { desc = 'Lazygit' })
end)
