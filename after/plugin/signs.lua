local signs = {
  error = {
    -- name = 'DiagnosticSignError',
    whole = '',
    hollow = '',
    text = 'e',
  },
  warn = {
    -- name = 'DiagnosticSignWarn',
    whole = '',
    hollow = '',
    text = 'w',
  },
  hint = {
    -- name = 'DiagnosticSignHint',
    whole = '',
    hollow = '',
    text = 'h',
  },
  info = {
    -- name = 'DiagnosticSignInfo',
    whole = '󰌵',
    hollow = '',
    text = 'i',
  },
}
local style = 'whole'
--[[
for _, sign in pairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign[style] })
end
]]
vim.diagnostic.config({signs = {
  text = {
    [vim.diagnostic.severity.ERROR] = signs.error[style],
    [vim.diagnostic.severity.WARN] = signs.warn[style],
    [vim.diagnostic.severity.HINT] = signs.hint[style],
    [vim.diagnostic.severity.INFO] = signs.error[style],
  },
}})
