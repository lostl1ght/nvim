---@type LazyPluginSpec
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  config = function()
    require('trouble').setup({
      modes = {
        diagnostics = {
          mode = 'diagnostics',
          focus = true,
          win = { position = 'top' },
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
        },
        lsp = {
          mode = 'lsp',
          focus = true,
          auto_refresh = false,
          win = { position = 'top', size = 0.3 },
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.5,
          },
          params = {
            include_current = true,
          },
        },
        symbols = {
          desc = 'document symbols',
          mode = 'lsp_document_symbols',
          focus = false,
          win = { position = 'right', size = 0.25 },
          preview = {
            type = 'split',
            relative = 'win',
            position = 'bottom',
            size = 0.3,
          },
        },
      },
    })
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(data)
        local util = require('util')
        local set = util.keymap_set
        set({
          'gd',
          '<cmd>Trouble lsp toggle<cr>',
          desc = 'Definitions / references / ...',
          buffer = data.buf,
        })
        set({
          '<leader>cd',
          '<cmd>Trouble diagnostics toggle<cr>',
          desc = 'Diagnostics',
          buffer = data.buf,
        })
        set({
          '<leader>cs',
          '<cmd>Trouble symbols toggle<cr>',
          desc = 'Symbols',
          buffer = data.buf,
        })
        util.set_mini_clue({
          key = '<leader>c',
          name = 'code',
          buf = data.buf,
        })
      end,
      group = vim.api.nvim_create_augroup('LspTrouble', {}),
    })
  end,
}
