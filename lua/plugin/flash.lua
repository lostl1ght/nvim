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
      treesitter = {
        label = { rainbow = { enabled = false, shade = 4 } },
        highlight = { backdrop = true },
      },
    },
    prompt = { prefix = { { ' 󱐋 ', 'FlashPromptIcon' } } },
  })

  local set = vim.keymap.set
  for key, name in pairs({ m = 'jump', M = 'treesitter' }) do
    set({ 'n', 'x', 'o' }, key, function()
      vim.lsp.buf.clear_references()
      require('flash')[name]()
    end, { desc = 'Flash ' .. name })
  end
end)
