vim.b.minitrailspace_disable = true
require('mini.trailspace').highlight()
--[[
local id
for _, match in ipairs(vim.fn.getmatches()) do
  if match.group == 'MiniTrailspace' then
    id = match.id
  end
end
pcall(vim.fn.matchdelete, id)
]]
