local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

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
    prompt = { prefix = { { ' 󱐋 ', 'FlashPromptIcon' } } },
  })

  local set = vim.keymap.set
  set({ 'n', 'x', 'o' }, 'm', function()
    vim.lsp.buf.clear_references()
    require('flash').jump()
  end, { desc = 'Flash jump' })
end)
