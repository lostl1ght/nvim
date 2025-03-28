vim.g.mapleader = ' '
vim.g.maplocalleader = ' m'

local set = vim.keymap.set
set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Escape terminal' })
set('i', 'ii', '<esc>', { desc = 'Escape isert' })
set('', '<f1>', '', { remap = true, desc = 'Unmap help' })
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  desc = 'Down but respect wrap',
})
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up but respect wrap' })
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
---@param rhs string|function
---@param desc string
local map_toggle = function(lhs, rhs, desc) set('n', prefix .. lhs, rhs, { desc = desc }) end
map_toggle('h', function()
  vim.cmd('let v:hlsearch=' .. bit.bxor(vim.v.hlsearch, 1))
  if vim.g.notify_toggle then vim.notify((vim.v.hlsearch == 1 and '' or 'no') .. 'hlsearch') end
  vim.schedule(function() vim.cmd('redrawstatus') end)
end, 'Search highlight')
map_toggle('i', function()
  vim.go.ignorecase = not vim.go.ignorecase
  if vim.g.notify_toggle then vim.notify(vim.go.ignorecase and 'ignorecase' or 'noignorecase') end
end, 'Ignore case')
map_toggle('r', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  if vim.g.notify_toggle then
    vim.notify(vim.wo.relativenumber and 'relativenumber' or 'norelativenumber')
  end
end, 'Relative numbers')
map_toggle('w', function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.g.notify_toggle then vim.notify(vim.wo.wrap and 'wrap' or 'nowrap') end
end, 'Wrap')
map_toggle('f', function()
  local no = ''
  if vim.wo.foldcolumn == 'auto' then
    vim.wo.foldcolumn = '0'
    no = 'no'
  else
    vim.wo.foldcolumn = 'auto'
  end
  if vim.g.notify_toggle then vim.notify(no .. 'foldcolumn') end
end, 'Fold column')
map_toggle('u', function()
  vim.wo.number = not vim.wo.number
  if vim.g.notify_toggle then vim.notify(vim.wo.number and 'number' or 'nonumber') end
end, 'Numbers')
map_toggle('s', function()
  local no = ''
  if vim.wo.signcolumn == 'yes' then
    vim.wo.signcolumn = 'no'
    no = 'no'
  else
    vim.wo.signcolumn = 'yes'
  end
  if vim.g.notify_toggle then vim.notify(no .. 'signcolumn') end
end, 'Sign column')

map_toggle('n', function()
  local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.b.inlay_hint_enabled = new_state
  vim.lsp.inlay_hint.enable(new_state, { bufnr = 0 })
  if vim.g.notify_toggle then
    local msg = new_state and 'inlayhint' or 'noinlayhint'
    vim.notify(msg)
  end
end, 'Inlay hints')
map_toggle('d', function()
  local buf_id = vim.api.nvim_get_current_buf()
  local new_state = not vim.diagnostic.is_enabled({ bufnr = buf_id })
  vim.diagnostic.enable(new_state, { bufnr = buf_id })
  if vim.g.notify_toggle then
    local msg = new_state and 'diagnostic' or 'nodiagnostic'
    vim.notify(msg)
  end
end, 'Diagnostics')
map_toggle('l', function()
  local new_state = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_state })
  if vim.g.notify_toggle then
    local msg = new_state and 'virtlines' or 'novirtlines'
    vim.notify(msg)
  end
end, 'Virtual lines')
set('n', 'grn', vim.lsp.buf.rename, {
  desc = 'Rename',
})
set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
  desc = 'Code action',
})
set('i', '<c-s>', vim.lsp.buf.signature_help, {
  desc = 'Signature help',
})
set('n', ']e', function() require('goto').next(vim.v.count1) end, {
  desc = 'Reference forward',
})
set('n', '[e', function() require('goto').prev(vim.v.count1) end, {
  desc = 'Reference backward',
})
set('n', ']E', function() require('goto').last() end, {
  desc = 'Reference last',
})
set('n', '[E', function() require('goto').first() end, {
  desc = 'Reference first',
})
pcall(vim.keymap.del, { 'i', 's' }, '<tab>')
pcall(vim.keymap.del, 'n', 'grr')
pcall(vim.keymap.del, 'n', 'gri')
