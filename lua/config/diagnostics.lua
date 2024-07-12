--[[
text = {
  [svr.ERROR] = '',
  [svr.WARN] = '',
  [svr.HINT] = '󰋽',
  [svr.INFO] = '󰌶',
},
]]
local svr = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [svr.ERROR] = '',
      [svr.WARN] = '',
      [svr.HINT] = '',
      [svr.INFO] = '',
    },
    numhl = {
      [svr.ERROR] = 'DiagnosticError',
      [svr.WARN] = 'DiagnosticWarn',
      [svr.HINT] = 'DiagnosticHint',
      [svr.INFO] = 'DiagnosticInfo',
    },
  },
  float = { border = vim.g.border },
  virtual_text = false,
})
