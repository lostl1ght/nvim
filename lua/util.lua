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
---@param buffer integer?
---@param opts util.MapOpts?
function M.keymap_set(map, buffer, opts)
  local modes
  if not map.mode then
    modes = { 'n' }
  elseif type(map.mode) == 'string' then
    modes = { map.mode }
  else
    ---@type string[]
    modes = map.mode
  end
  vim.keymap.set(modes, map[1], map[2], { buffer = buffer, desc = map.desc })

  if not opts then
    return
  end

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
