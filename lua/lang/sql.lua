local M = {}
function M.setup()
    local g = vim.g

    g.dbs = {
        lab01 = 'postgresql://master:@localhost/lab01',
    }
end

return M
