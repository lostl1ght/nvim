local M = {}

---@param cmd string
---@param args string
---@return string
---@return string[]
M.parse = function(cmd, args)
  local parts = vim.split(vim.trim(args), '%s+')
  if parts[1]:find(cmd) then table.remove(parts, 1) end
  if args:sub(-1) == ' ' then table.insert(parts, '') end
  return table.remove(parts, 1) or '', parts
end

---@param line string
---@param cmd string
---@param commands function[]
---@return string[]?
M.complete = function(line, cmd, commands)
  local prefix, args = M.parse(cmd, line)
  if #args > 0 then return end
  return vim.tbl_filter(function(key) return key:find(prefix) == 1 end, vim.tbl_keys(commands))
end

---@param cmd string[]
M.build_package = function(cmd)
  ---@param spec {path:string,name:string,source:string}
  return function(spec)
    require('mini.deps').later(function()
      local levels = vim.log.levels
      vim.notify(('(mini.deps) Building `%s`'):format(spec.name), levels.INFO)
      vim.system(cmd, { cwd = spec.path, text = true }, function(obj)
        local msg = ''
        local lvl = levels.INFO
        if obj.code ~= 0 then
          lvl = levels.ERROR
          msg = ('\nCode %d\n%s'):format(obj.code, obj.stderr)
        end
        vim.schedule(
          function()
            vim.notify(('(mini.deps) Finished building `%s`%s'):format(spec.name, msg), lvl)
          end
        )
      end)
    end)
  end
end

return M
