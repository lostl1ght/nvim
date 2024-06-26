return {
  'm-demare/hlargs.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('hlargs').setup({
      excluded_argnames = {
        declarations = {
          python = { 'self', 'cls' },
          lua = { 'self' },
        },
        usages = {
          python = { 'self', 'cls' },
          lua = { 'self' },
        },
      },
      hl_priority = 150,
    })
  end,
}
