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
          win = { position = 'top' },
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
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
            '<leader>cD',
            '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
            desc = 'Buffer diagnostics',
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
