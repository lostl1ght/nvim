local M = {}

M.load = function()
    require('ll.core.settings')
    require('ll.core.provider')
    require('ll.core.filetypes')
end

M.init = function()
    pcall(require, 'impatient')
    require('ll.plugin.loader'):init()
    llvim = {}
end

return M
