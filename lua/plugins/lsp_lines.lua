---@type LazyPluginSpec
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
        local util = require('util')
        local set = util.keymap_set
        set({
          '<leader>cl',
          function()
            ---@diagnostic disable-next-line: undefined-field
            local new_value = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_value })
            vim.notify(
              string.format('lines %s', new_value and 'enabled' or 'disabled'),
              vim.log.levels.INFO,
              { title = 'Diagnostics' }
            )
          end,
          desc = 'Line diagnostics',
          buffer = data.buf,
        })
        util.set_mini_clue({
          key = '<leader>c',
          name = 'code',
          buf = data.buf,
        })
      end,
      group = vim.api.nvim_create_augroup('LspLinesGroup', {}),
    })
  end,
}
