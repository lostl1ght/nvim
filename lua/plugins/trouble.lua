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
          win = { position = 'top', size = 0.4 },
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
        local maps = {
          {
            'gd',
            '<cmd>Trouble lsp toggle<cr>',
            desc = 'Definitions / references / ...',
          },
          {
            '<leader>cd',
            '<cmd>Trouble diagnostics toggle<cr>',
            desc = 'Diagnostics',
          },
          {
            '<leader>cs',
            '<cmd>Trouble symbols toggle<cr>',
            desc = 'Symbols',
          },
        }
        for _, map in ipairs(maps) do
          util.keymap_set(map, data.buf)
        end
      end,
      group = vim.api.nvim_create_augroup('LspTrouble', {}),
    })
  end,
}
