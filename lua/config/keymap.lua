local set = vim.keymap.set
set('t', '<esc><esc>', '<c-\\><c-n>')
set('i', 'ii', '<esc>')
set('', '<f1>', '', { remap = true })
set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
set('n', 'x', '"_x', { desc = 'Delete single char without clipboard' })
set('n', '<c-w>+', function() return vim.v.count1 * 3 .. '<c-w>+' end, {
  expr = true,
  desc = 'Increase height',
})
set('n', '<c-w>-', function() return vim.v.count1 * 3 .. '<c-w>-' end, {
  expr = true,
  desc = 'Decrease height',
})
set('n', '<c-w>>', function() return vim.v.count1 * 3 .. '<c-w>>' end, {
  expr = true,
  desc = 'Increase width',
})
set('n', '<c-w><', function() return vim.v.count1 * 3 .. '<c-w><' end, {
  expr = true,
  desc = 'Decrease width',
})
set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  expr = true,
  replace_keycodes = false,
  desc = 'Visually select changed text',
})
set('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
set('n', 'gO', "v:lua.require'util'.put_empty_line(v:true)", {
  expr = true,
  desc = 'Put empty line above',
})
set('n', 'go', "v:lua.require'util'.put_empty_line(v:false)", {
  expr = true,
  desc = 'Put empty line below',
})

local prefix = '\\'
---@param lhs string
---@param rhs string
---@param desc string
local map_toggle = function(lhs, rhs, desc) set('n', prefix .. lhs, rhs, { desc = desc }) end
map_toggle(
  'h',
  '<cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<cr>',
  'Search highlight'
)
map_toggle('c', '<cmd>setlocal cursorline! cursorline?<cr>', 'Cursor line')
map_toggle('i', '<cmd>setlocal ignorecase! ignorecase?<cr>', 'Ignore case')
map_toggle('r', '<cmd>setlocal relativenumber! relativenumber?<cr>', 'Relative numbers')
map_toggle('w', '<cmd>setlocal wrap! wrap?<cr>', 'Wrap')

set('n', 'grn', vim.lsp.buf.rename, {
  desc = 'Rename',
})
set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
  desc = 'Code action',
})
set('i', '<c-s>', vim.lsp.buf.signature_help, {
  desc = 'Signature help',
})
set('n', '\\l', function()
  local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.b.inlay_hint_enabled = new_state
  vim.lsp.inlay_hint.enable(new_state, { bufnr = 0 })
  local msg = new_state and 'inlayhint' or 'noinlayhint'
  print(msg)
end, {
  desc = 'Inlay hints',
})
set('n', '\\t', function()
  local buf_id = vim.api.nvim_get_current_buf()
  local new_state = not vim.diagnostic.is_enabled({ bufnr = buf_id })
  vim.diagnostic.enable(new_state, { bufnr = buf_id })
  local msg = new_state and 'diagnostic' or 'nodiagnostic'
  print(msg)
end, {
  desc = 'Diagnostics',
})
set('n', ']e', function() require('goto').next(vim.v.count) end, {
  desc = 'Reference forward',
})
set('n', '[e', function() require('goto').prev(vim.v.count) end, {
  desc = 'Reference backward',
})
set('n', ']E', function() require('goto').last() end, {
  desc = 'Reference last',
})
set('n', '[E', function() require('goto').first() end, {
  desc = 'Reference first',
})
