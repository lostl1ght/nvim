local M = {}
local H = {}

---@param fdt {[1]:string,[2]:string}[]
---@return {[1]:string,[2]:string}
H.fill = function(fdt)
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
  local n = wininfo.width - wininfo.textoff
  for _, part in ipairs(fdt) do
    n = n - vim.fn.strdisplaywidth(part[1])
  end
  return { (' '):rep(n) or '', 'Folded' }
end

---@param fdt {[1]:string,[2]:string}[]
---@return {[1]:string,[2]:string}[]
H.suffix = function(fdt)
  table.insert(fdt, { ' <-- ', 'Folded' })
  table.insert(fdt, { ('%d lines '):format(vim.v.foldend - vim.v.foldstart), 'Folded' })
  table.insert(fdt, #fdt, H.fill(fdt))
  return fdt
end

---@return {[1]:string,[2]:string}[]
M.get = function() return H.suffix({ { vim.fn.getline(vim.v.foldstart), 'Folded' } }) end

return M
