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

function M.is_normal_buffer(buffer)
  return #vim.api.nvim_buf_get_option(buffer, 'buftype') == 0 and vim.api.nvim_buf_get_option(buffer, 'buflisted')
end

function M.clear_abnormal()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buffer) and not M.is_normal_buffer(buffer) then
            vim.api.nvim_buf_delete(buffer, { force = true })
        end
    end
end

function M.clear_normal()
    local cur_buf = vim.api.nvim_get_current_buf()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buffer) and M.is_normal_buffer(buffer) and buffer ~= cur_buf then
            vim.api.nvim_buf_delete(buffer, { force = true })
        end
    end
end

return M

