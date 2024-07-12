local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'folke/trouble.nvim' })
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(data)
      local set = vim.keymap.set
      local bufnr = data.buf
      set('n', 'gd', '<cmd>Trouble lsp<cr>', {
        desc = 'Definitions / references / ...',
        buffer = bufnr,
      })
      set('n', 'grd', '<cmd>Trouble diagnostics toggle<cr>', {
        desc = 'Diagnostics',
        buffer = bufnr,
      })
      set('n', 'grs', '<cmd>Trouble symbols toggle<cr>', {
        desc = 'Symbols',
        buffer = bufnr,
      })
    end,
    group = vim.api.nvim_create_augroup('LspTrouble', {}),
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
