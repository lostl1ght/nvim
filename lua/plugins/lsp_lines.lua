return {
  url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    require('lsp_lines').setup()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      float = { border = 'single' },
    })
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(data)
        local map = {
          '<leader>tl',
          function()
            vim.notify(
              string.format('lines %s', require('lsp_lines').toggle() and 'enabled' or 'disabled'),
              vim.log.levels.INFO,
              { title = 'Diagnostics' }
            )
          end,
          desc = 'Line diagnostics',
        }
        local util = require('util')
        util.keymap_set(map, data.buf)
      end,
      group = vim.api.nvim_create_augroup('LspLinesGroup', {}),
    })
  end,
}
