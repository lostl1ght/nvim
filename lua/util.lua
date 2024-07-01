local M = {}

function M.list_concat(...)
  local res = {}
  for i = 1, select('#', ...) do
    for _, x in ipairs(select(i, ...) or {}) do
      table.insert(res, x)
    end
  end
  return res
end

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

---@class util.McOpts
---@field key string
---@field name string
---@field mode string
---@field buf integer?

---@param opts util.McOpts
function M.set_mini_clue(opts)
  local ok, mc = pcall(require, 'mini.clue')
  if not ok then
    return
  end
  local cfg
  if opts.buf then
    cfg = vim.b[opts.buf].miniclue_config or { clues = {} }
  else
    cfg = mc.config
  end
  local clue = { mode = opts.mode or 'n', keys = opts.key, desc = '+' .. opts.name }
  if
    not vim.tbl_contains(cfg.clues, function(v)
      return v.mode == clue.mode and v.keys == clue.keys
    end, { predicate = true })
  then
    table.insert(cfg.clues, clue)
  end

  if opts.buf and #cfg.clues > 0 then
    vim.b[opts.buf].miniclue_config = cfg
  end
end

---@class util.Map
---@field [1] string
---@field [2] string|function
---@field mode string|string[]
---@field desc string

---@param map util.Map
function M.keymap_set(map)
  map.mode = map.mode or 'n'
  local map_opts = {}
  for key, val in pairs(map) do
    if type(key) ~= 'number' and key ~= 'mode' then
      map_opts[key] = val
    end
  end
  vim.keymap.set(map.mode, map[1], map[2], map_opts)
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
