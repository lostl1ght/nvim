local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add({ source = 'folke/trouble.nvim' })
  local set = vim.keymap.set
  set('n', 'gd', '<cmd>Trouble lsp<cr>', {
    desc = 'Definitions / references / ...',
  })
  set('n', 'grd', '<cmd>Trouble diagnostics toggle<cr>', {
    desc = 'Diagnostics',
  })
  set('n', 'grs', '<cmd>Trouble symbols toggle<cr>', {
    desc = 'Symbols',
  })
  require('trouble').setup({
    modes = {
      diagnostics = {
        mode = 'diagnostics',
        focus = true,
        win = { position = 'top' },
      },
      lsp = {
        mode = 'lsp',
        focus = true,
        auto_refresh = false,
        win = { position = 'top' },
        params = { include_current = true },
      },
      symbols = {
        desc = 'document symbols',
        mode = 'lsp_document_symbols',
        auto_preview = false,
        win = { position = 'right', size = 0.25 },
      },
    },
  })
end)
