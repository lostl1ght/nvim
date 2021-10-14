local M = {}

-- If a buffer is a terminal close it
function M.close_term()
    if vim.bo.buftype == 'terminal' then
        vim.cmd 'close'
    end
end

-- Bootstrapping
function M.installed()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    local installed = true
    if fn.empty(fn.glob(install_path)) > 0 then
       installed = false
       fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    end
    return installed
end

function M.install()
    require('core.plugins')
    require('packer').sync()
    require('core.packer').autocompile()
end

return M

