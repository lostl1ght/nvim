safely('now', function()
  vim.pack.add({ gh('nvim-mini/mini.icons') }, { confirm = false })
  require('mini.icons').setup()
end)
