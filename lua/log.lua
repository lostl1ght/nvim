local lvls = vim.log.levels

---@class util.Logger
local logger = {}

local normalize = function(msg) return type(msg) == 'string' and msg or vim.inspect(msg) end

---@param msg any
---@param lvl integer
---@return any
logger.log = function(msg, lvl)
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
logger.info = function(msg) return logger.log(msg, lvls.INFO) end

---@param msg any
---@return any
logger.warn = function(msg) return logger.log(msg, lvls.WARN) end

---@param msg any
---@return any
logger.error = function(msg) return logger.log(msg, lvls.ERROR) end

---@param msg any
---@return any
logger.debug = function(msg) return logger.log(msg, lvls.DEBUG) end

return logger
