local M = {}

-- Python debugger
function M.setup()
    require('dap-python').setup('~/.pyenv/versions/3.9.7/envs/debugpy/bin/python')
end

return M
