local M = {}

function M.init()
    pcall(require, 'impatient')
    require('ll.plugin.loader'):init()
end

return M