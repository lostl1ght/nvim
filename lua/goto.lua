local M = {}
local H = {}

H.pos_before = function(pos1, pos2)
  return pos1[1] == pos2[1] and pos1[2] < pos2[2] or pos1[1] < pos2[1]
end

H.bisect_left = function(refs, pos)
  local left, right = 1, #refs + 1
  while left < right do
    local mid = left + math.floor((right - left) / 2)
    if H.pos_before(refs[mid], pos) then
      left = mid + 1
    else
      right = mid
    end
  end
  return left
end

H.pos_equal = function(pos1, pos2) return pos1[1] == pos2[1] and pos1[2] == pos2[2] end

H.sorted_refs = function(result)
  local refs = {}
  for _, v in ipairs(result) do
    table.insert(refs, { v.range.start.line + 1, v.range.start.character })
  end
  table.sort(refs, H.pos_before)
  return refs
end

H.notify_error = function(msg) vim.api.nvim_echo({ { msg } }, true, { err = true }) end

H.err_top = function() H.notify_error('E384: search hit TOP of the references') end

H.err_bot = function() H.notify_error('E385: search hit BOTTOM of the references') end

H.err_req = function() H.notify_error('Reference request error') end

H.move_index = function(idx, len, step)
  idx = idx + step
  if idx < 1 or idx > len then
    if vim.o.wrapscan then
      idx = (idx < 1) and len or 1
    else
      return 0
    end
  end
  return idx
end

H.goto_ref = function(result, count, dir)
  if not result or #result <= 1 then return end
  local refs = H.sorted_refs(result)
  local len = #refs
  local cursor = vim.api.nvim_win_get_cursor(0)
  local idx = H.bisect_left(refs, cursor)

  if dir > 0 then
    if not refs[idx] or H.pos_equal(cursor, refs[idx]) then
      idx = H.move_index(idx, len, 1)
      if idx == 0 then return H.err_bot() end
    end
    for _ = 1, count do
      idx = H.move_index(idx, len, 1)
      if idx == 0 then return H.err_bot() end
    end
  else
    if not H.pos_equal(cursor, refs[math.min(idx, len)]) then
      idx = H.move_index(idx, len, -1)
      if idx == 0 then return H.err_top() end
    end
    idx = H.move_index(idx, len, -1)
    if idx == 0 then return H.err_top() end
    for _ = 1, count do
      idx = H.move_index(idx, len, -1)
      if idx == 0 then return H.err_top() end
    end
  end

  vim.cmd('normal! m`')
  vim.api.nvim_win_set_cursor(0, refs[idx])
end

H.goto_next = function(count)
  return function(err, result)
    if err then return H.err_req() end
    H.goto_ref(result, count, 1)
  end
end

H.goto_prev = function(count)
  return function(err, result)
    if err then return H.err_req() end
    H.goto_ref(result, count, -1)
  end
end

H.goto_first = function()
  return function(err, result)
    if err then return H.err_req() end
    if not result or #result <= 1 then return end
    local pos = H.sorted_refs(result)[1]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

H.goto_last = function()
  return function(err, result)
    if err then return H.err_req() end
    if not result or #result <= 1 then return end
    local pos = H.sorted_refs(result)[#result]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

H.method = vim.lsp.protocol.Methods.textDocument_documentHighlight

H.get_client = function(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = H.method })
  if #clients == 0 then return end
  return clients[1]
end

H.make_goto_func = function(callback)
  return function(count)
    local client = H.get_client()
    if not client then return end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    ---@diagnostic disable-next-line: inject-field
    params.context = { includeDeclaration = true }
    client:request(H.method, params, callback(count - 1), 0)
  end
end

M.next = H.make_goto_func(H.goto_next)
M.prev = H.make_goto_func(H.goto_prev)
M.first = H.make_goto_func(H.goto_first)
M.last = H.make_goto_func(H.goto_last)

return M
