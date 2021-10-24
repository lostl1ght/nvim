local M = {}

function M.init()
    local present, _ = pcall(require, 'impatient')
    require('mars.plugin.loader'):init()
end

return M