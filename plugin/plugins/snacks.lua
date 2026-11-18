safely('later', function()
  packadd({ 'folke/snacks.nvim' })

  require('snacks').setup({
    indent = {},
    input = {},
    lazygit = {
      config = {
        os = { editPreset = 'nvim' },
      },
    },
    scroll = {},
    styles = {
      float = { backdrop = 80 },
      input = {
        backdrop = 90,
        border = vim.g.border,
        title_pos = 'left',
        relative = 'cursor',
        row = -3,
        col = 1,
      },
    },
  })

  vim.keymap.set('n', 'gl', function() Snacks.lazygit() end, { desc = 'Lazygit' })
end)

safely('now', function()
  packadd({ { src = 'lostl1ght/flatten.nvim', version = 'develop' } })
  require('flatten').setup({
    window = { open = 'smart' },
    callbacks = {
      pre_open = vim.schedule_wrap(function() Snacks.lazygit() end),
      post_open = function(buf_id)
        if vim.list_contains({ 'gitcommit', 'gitrebase' }, vim.bo[buf_id].filetype) then
          vim.api.nvim_create_autocmd('BufWritePost', {
            buffer = buf_id,
            once = true,
            callback = vim.schedule_wrap(function() require('mini.bufremove').delete(buf_id) end),
          })
        end
      end,
      block_end = vim.schedule_wrap(function() Snacks.lazygit() end),
    },
  })
end)
