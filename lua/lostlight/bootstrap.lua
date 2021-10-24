local M = {}

function M.init()
    local present, _ = pcall(require, 'impatient')
    require('lostlight.plugin.loader'):init()
end

return M