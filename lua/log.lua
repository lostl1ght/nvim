local lvls = vim.log.levels

local LOG = {}

local normalize = function(msg) return type(msg) == 'string' and msg or vim.inspect(msg) end

---@param msg any
---@param lvl integer?
---@return any
LOG.log = function(msg, lvl)
  local config = vim.g.logcfg or {}

  if not config.enabled then return msg end

  local title = config.name
  lvl = lvl or lvls.INFO
  msg = normalize(msg)

  if lvl == lvls.DEBUG then msg = debug.traceback(msg .. '\n') end

  vim.notify(msg, lvl, { title = title })
  return msg
end

---@param msg any
---@return any
LOG.info = function(msg) return LOG.log(msg) end

---@param msg any
---@return any
LOG.warn = function(msg) return LOG.log(msg, lvls.WARN) end

---@param msg any
---@return any
LOG.error = function(msg) return LOG.log(msg, lvls.ERROR) end

---@param msg any
---@return any
LOG.debug = function(msg) return LOG.log(msg, lvls.DEBUG) end

return LOG
