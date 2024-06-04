vim.opt_local.buflisted = false
local bufnr = vim.fn.bufnr()
vim.keymap.set('n', 'q', function()
  vim.api.nvim_cmd({ cmd = 'bdelete', args = { bufnr } }, {})
end, { buffer = bufnr })

--[[
local ok, trouble = pcall(require, 'trouble')
if ok then
  -- Check whether we deal with a quickfix or location list buffer, close the window and open the
  -- corresponding Trouble window instead.
  if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    vim.schedule(function()
      vim.cmd.lclose()
      trouble.open('loclist')
    end)
  else
    vim.schedule(function()
      vim.cmd.cclose()
      trouble.open('quickfix')
    end)
  end
end
]]
