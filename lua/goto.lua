local pos_before = function(pos1, pos2)
  return pos1[1] == pos2[1] and pos1[2] < pos2[2] or pos1[1] < pos2[1]
end

local bisect_left = function(refs, pos)
  local left, right = 1, #refs + 1
  while left < right do
    local mid = left + math.floor((right - left) / 2)
    if pos_before(refs[mid], pos) then
      left = mid + 1
    else
      right = mid
    end
  end
  return left
end

local pos_equal = function(pos1, pos2) return pos1[1] == pos2[1] and pos1[2] == pos2[2] end

local sorted_refs = function(result)
  local refs = {}
  for _, v in ipairs(result) do
    table.insert(refs, { v.range.start.line + 1, v.range.start.character })
  end
  table.sort(refs, pos_before)
  return refs
end

local notify_error = function(msg) vim.api.nvim_echo({ { msg } }, true, { err = true }) end

local err_top = function() notify_error('E384: search hit TOP of the references') end

local err_bot = function() notify_error('E385: search hit BOTTOM of the references') end

local err_req = function() notify_error('Reference request error') end

local move_index = function(idx, len, step)
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

local goto_ref = function(result, count, dir)
  if not result or #result <= 1 then return end
  local refs = sorted_refs(result)
  local len = #refs
  local cursor = vim.api.nvim_win_get_cursor(0)
  local idx = bisect_left(refs, cursor)

  if dir > 0 then
    if pos_equal(cursor, refs[idx]) then
      idx = move_index(idx, len, 1)
      if idx == 0 then return err_bot() end
    end
    for _ = 1, count do
      idx = move_index(idx, len, 1)
      if idx == 0 then return err_bot() end
    end
  else
    if not pos_equal(cursor, refs[math.min(idx, len)]) then
      idx = move_index(idx, len, -1)
      if idx == 0 then return err_top() end
    end
    idx = move_index(idx, len, -1)
    if idx == 0 then return err_top() end
    for _ = 1, count do
      idx = move_index(idx, len, -1)
      if idx == 0 then return err_top() end
    end
  end

  vim.cmd('normal! m`')
  vim.api.nvim_win_set_cursor(0, refs[idx])
end

local goto_next = function(count)
  return function(err, result)
    if err then return err_req() end
    goto_ref(result, count, 1)
  end
end

local goto_prev = function(count)
  return function(err, result)
    if err then return err_req() end
    goto_ref(result, count, -1)
  end
end

local goto_first = function()
  return function(err, result)
    if err then return err_req() end
    if not result or #result <= 1 then return end
    local pos = sorted_refs(result)[1]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local goto_last = function()
  return function(err, result)
    if err then return err_req() end
    if not result or #result <= 1 then return end
    local pos = sorted_refs(result)[#result]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local make_goto_func = function(callback)
  return function(count)
    local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(0))
    ---@diagnostic disable-next-line: inject-field
    params.context = { includeDeclaration = true }
    vim.lsp.buf_request(
      0,
      vim.lsp.protocol.Methods.textDocument_documentHighlight,
      params,
      callback(count - 1)
    )
  end
end

return {
  next = make_goto_func(goto_next),
  prev = make_goto_func(goto_prev),
  first = make_goto_func(goto_first),
  last = make_goto_func(goto_last),
}
