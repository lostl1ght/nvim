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

return M

