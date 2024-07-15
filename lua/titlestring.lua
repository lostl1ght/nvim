local M = {}

M.get = function()
  return vim.fn.fnamemodify(vim.uv.cwd() --[[@as string]], ':~:.')
end

return M
