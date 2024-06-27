local M = {}

---@class util.Map
---@field [1] string
---@field [2] string|function
---@field mode string|string[]
---@field desc string

---@class util.MapOpts
---@field key string
---@field name string

---@param map util.Map
---@param opts util.MapOpts?
function M.keymap_set(map, opts)
  local modes
  if map.mode == nil then
    modes = { 'n' }
  elseif type(map.mode) == 'string' then
    modes = { map.mode }
  else
    ---@type string[]
    modes = map.mode
  end
  local map_opts = {}
  for key, val in pairs(map) do
    if type(key) ~= 'number' and key ~= 'mode' then
      map_opts[key] = val
    end
  end
  vim.keymap.set(modes, map[1], map[2], map_opts)

  if not opts then
    return
  end

  local buffer = map_opts.buffer
  local okw, wk = pcall(require, 'which-key')
  if okw then
    wk.register({
      [opts.key] = { name = opts.name },
    }, { buffer = buffer, mode = map.mode })
  end
end

---@param cmd string
---@param args string
---@return string
---@return string[]
function M.parse(cmd, args)
  local parts = vim.split(vim.trim(args), '%s+')
  if parts[1]:find(cmd) then
    table.remove(parts, 1)
  end
  if args:sub(-1) == ' ' then
    table.insert(parts, '')
  end
  return table.remove(parts, 1) or '', parts
end

---@param line string
---@param cmd string
---@param commands function[]
---@return string[]?
function M.complete(line, cmd, commands)
  local prefix, args = M.parse(cmd, line)
  if #args > 0 then
    return
  end
  return vim.tbl_filter(function(key)
    return key:find(prefix) == 1
  end, vim.tbl_keys(commands))
end

return M
