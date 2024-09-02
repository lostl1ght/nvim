local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'mfussenegger/nvim-lint' })
  require('lint').linters_by_ft = {
    go = { 'golangcilint' },
  }
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function() require('lint').try_lint() end,
  })
end)
