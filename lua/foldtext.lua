local M = {}

---@param fdt {[1]:string,[2]:string}[]
---@return {[1]:string,[2]:string}
local fill = function(fdt)
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
  local n = wininfo.width - wininfo.textoff
  for _, part in ipairs(fdt) do
    n = n - vim.fn.strdisplaywidth(part[1])
  end
  return { (' '):rep(n) or '', 'Folded' }
end

---@param fdt {[1]:string,[2]:string}[]
---@return {[1]:string,[2]:string}[]
local suffix = function(fdt)
  table.insert(fdt, { ' <-- ', 'Folded' })
  table.insert(fdt, { ('%d lines '):format(vim.v.foldend - vim.v.foldstart), 'Folded' })
  table.insert(fdt, #fdt, fill(fdt))
  return fdt
end

---@return {[1]:string,[2]:string}[]
local line_foldtext = function() return suffix({ { vim.fn.getline(vim.v.foldstart), 'Folded' } }) end

--[[
---@param parser vim.treesitter.LanguageTree
---@param query vim.treesitter.Query
---@return {[1]:string,[2]:string}[]
local treesitter_foldtext = function(parser, query)
  local pos = vim.v.foldstart
  local line = vim.fn.getline(vim.v.foldstart)
  local tree = parser:parse({ pos - 1, pos })[1]
  local line_pos = 0
  local prev_range
  local foldtext = {}
  for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    if start_row == pos - 1 and end_row == pos - 1 then
      local range = { start_col, end_col }
      if start_col > line_pos then
        local text = line:sub(line_pos + 1, start_col)
        table.insert(foldtext, { text, 'Folded' })
      end
      line_pos = end_col
      local text = vim.treesitter.get_node_text(node, 0)
      if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
        foldtext[#foldtext] = { text, '@' .. name }
      else
        table.insert(foldtext, { text, '@' .. name })
      end
      prev_range = range
    end
  end
  return suffix(foldtext)
end

---@return {[1]:string,[2]:string}[]
M.get = function()
  local ok, parser = pcall(vim.treesitter.get_parser)
  if ok then
    local query = vim.treesitter.query.get(parser:lang(), 'highlights')
    if query then return treesitter_foldtext(parser, query) end
  end
  return line_foldtext()
end
]]

---@return {[1]:string,[2]:string}[]
M.get = line_foldtext

return M
