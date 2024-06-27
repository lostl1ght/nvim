local M = {}

---@class util.WkOpts
---@field key string
---@field name string
---@field buf integer?
---@field mode string|string[]?

---@param opts util.WkOpts
function M.set_which_key(opts)
  local ok, wk = pcall(require, 'which-key')
  if not ok then
    return
  end
  wk.register({
    [opts.key] = { name = opts.name },
  }, { buffer = opts.buf, mode = opts.mode })
end

---@class util.Map
---@field [1] string
---@field [2] string|function
---@field mode string|string[]
---@field desc string

---@param map util.Map
function M.keymap_set(map)
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
