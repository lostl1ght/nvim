local M = {}

function M.init()
    pcall(require, 'impatient')
    require('ll.plugin.loader'):init()
    llvim = {}
end

return M
