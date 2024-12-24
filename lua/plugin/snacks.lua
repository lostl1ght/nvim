local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

later(function()
  add({ source = 'folke/snacks.nvim' })
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

  vim.keymap.set('n', '<leader>g', function() Snacks.lazygit() end, { desc = 'Lazygit' })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
  })
end)

now(function()
  -- add({ source = 'willothy/flatten.nvim' })
  add({ source = 'lostl1ght/flatten.nvim', checkout = 'develop' })
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
