local M = {}

function M.keymap_set(map, buffer, wkopts)
  if not map.mode then
    map.mode = 'n'
  end
  vim.keymap.set(map.mode, map[1], map[2], { buffer = buffer, desc = map.desc })
  if not wkopts then
    return
  end
  local ok, wk = pcall(require, 'which-key')
  if not ok then
    return
  end
  wk.register({
    [wkopts.prefix.key] = { name = wkopts.prefix.name },
  }, { buffer = buffer, mode = map.mode })
end

function M.trim_state(buf)
  buf = buf or 0
  local val = vim.b[buf].trim_trailing_whitespace
  return val == nil and true or val
end

return M
