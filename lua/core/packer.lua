local M = {}

-- Compile on save
function M.autocompile()
    vim.cmd([[
        augroup packer_user_config
            autocmd!
            autocmd BufWritePost packer.lua source <afile> | PackerCompile
        augroup end
    ]])
end

return M

