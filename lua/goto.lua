local pos_before = function(pos1, pos2)
  if pos1[1] == pos2[1] then
    return pos1[2] < pos2[2]
  else
    return pos1[1] < pos2[1]
  end
end

local bisect_left = function(references, pos)
  local left, right = 1, #references + 1
  while left < right do
    local middle = left + math.floor((right - left) / 2)
    if pos_before(references[middle], pos) then
      left = middle + 1
    else
      right = middle
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

local rerror = function()
  vim.notify('reference request error', vim.log.levels.ERROR, { title = 'Lsp' })
end

local check_wrap = function(idx, fin, wrap)
  local ok = true
  if idx == fin then
    if vim.o.wrapscan then
      idx = wrap
    else
      ok = false
    end
  end
  return ok, idx
end

local inc_or_exit = function(idx, len)
  idx = idx + 1
  return check_wrap(idx, len + 1, 1)
end

local dec_or_exit = function(idx, len)
  idx = idx - 1
  return check_wrap(idx, 0, len)
end

local goto_next = function(count)
  return function(err, result)
    if err then
      rerror()
      return
    end
    if not result or #result == 1 then return end
    local refs = sorted_refs(result)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local idx = bisect_left(refs, cursor)
    local ok
    ok, idx = check_wrap(idx, #refs + 1, 1)
    if not ok then
      vim.api.nvim_err_writeln('E385: search hit BOTTOM of the references')
      return
    end
    if pos_equal(cursor, refs[idx]) then
      ok, idx = inc_or_exit(idx, #refs)
      if not ok then
        vim.api.nvim_err_writeln('E385: search hit BOTTOM of the references')
        return
      end
    end
    if count > 0 then
      for _ = 1, count do
        ok, idx = inc_or_exit(idx, #refs)
        if not ok then
          vim.api.nvim_err_writeln('E385: search hit BOTTOM of the references')
          return
        end
      end
    end
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, refs[idx])
  end
end

local goto_prev = function(count)
  return function(err, result)
    if err then
      rerror()
      return
    end
    if not result or #result == 1 then return end
    local refs = sorted_refs(result)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local idx = bisect_left(refs, cursor)
    local ok
    if not pos_equal(cursor, refs[idx > #refs and #refs or idx]) then
      ok, idx = dec_or_exit(idx, #refs)
      if not ok then
        vim.api.nvim_err_writeln('E384: search hit TOP of the references')
        return
      end
    end
    ok, idx = dec_or_exit(idx, #refs)
    if not ok then
      vim.api.nvim_err_writeln('E384: search hit TOP of the references')
      return
    end
    if count > 0 then
      for _ = 1, count do
        ok, idx = dec_or_exit(idx, #refs)
        if not ok then
          vim.api.nvim_err_writeln('E384: search hit TOP of the references')
          return
        end
      end
    end
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, refs[idx])
  end
end

local goto_last = function()
  return function(err, result)
    if err then
      rerror()
      return
    end
    if not result or #result == 1 then return end
    local pos = sorted_refs(result)[#result]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local goto_first = function()
  return function(err, result)
    if err then
      rerror()
      return
    end
    if not result or #result == 1 then return end
    local pos = sorted_refs(result)[1]
    vim.cmd('normal! m`')
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local wrap_request = function(callback)
  return function(count)
    count = count or 0
    local params = vim.lsp.util.make_position_params()
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
  next = wrap_request(goto_next),
  prev = wrap_request(goto_prev),
  first = wrap_request(goto_first),
  last = wrap_request(goto_last),
}
