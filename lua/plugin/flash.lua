local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add({ source = 'folke/flash.nvim' })
  require('flash').setup({
    search = {
      exclude = {
        'notify',
        'cmp_menu',
        'cmp_docs',
        'noice',
        'flash_prompt',
        function(win) return not vim.api.nvim_win_get_config(win).focusable end,
      },
    },
    modes = {
      search = { enabled = false },
      char = { jump_labels = true },
      treesitter = { label = { rainbow = { enabled = true, shade = 4 } } },
      treesitter_search = { label = { rainbow = { enabled = true, shade = 4 } } },
    },
    prompt = { prefix = { { '󱐋 ', 'FlashPromptIcon' } } },
  })

  local set = vim.keymap.set
  set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
  set(
    { 'n', 'x', 'o' },
    'S',
    function() require('flash').treesitter() end,
    { desc = 'Flash treesitter' }
  )
  set('o', 'r', function() require('flash').remote() end, { desc = 'Remote flash' })
  set(
    { 'o', 'x' },
    'R',
    function() require('flash').treesitter_search() end,
    { desc = 'Flash treesitter Search' }
  )
  set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle flash Search' })
end)
