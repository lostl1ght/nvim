local M = {}

-- If close debugger terminal
function M.close_term()
    local bufinfo = vim.fn.getbufinfo()
    for _, k in ipairs(bufinfo) do
        if string.find(k['name'], 'term://.*/sh') then
            vim.api.nvim_buf_delete(k['bufnr'], {force = true})
        end
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

