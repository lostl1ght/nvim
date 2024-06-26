return {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local rd = require('rainbow-delimiters')
    vim.g.rainbow_delimiters = {
      strategy = {
        -- [''] = rd.strategy['global'], -- https://github.com/HiPhish/rainbow-delimiters.nvim/issues/2
        [''] = rd.strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        latex = 'rainbow-blocks',
      },
      priority = {
        [''] = 250,
      },
    }
  end,
}
