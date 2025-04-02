local M = {}

local get_signs = function(buf, lnum)
  local signs = {}

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = 'sign' }
  )
  for _, extmark in pairs(extmarks) do
    table.insert(signs, {
      name = extmark[4].sign_name or extmark[4].sign_hl_group or '',
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end

  -- Sort by priority
  table.sort(signs, function(a, b) return (a.priority or 0) < (b.priority or 0) end)

  return signs
end

local icon = function(sign, len)
  sign = sign or {}
  len = len or 1
  local text = vim.fn.strcharpart(sign.text or '', 0, len)
  text = text .. string.rep(' ', len - vim.fn.strchars(text))
  return sign.texthl and ('%#' .. sign.texthl .. '#' .. text .. '%*') or text
end

M.get = function()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local show_signs = vim.wo.signcolumn ~= 'no'

  -- fold, git, other, numbers, dap
  local components = { '%C', '', '', '%=%l', ' ' }

  if vim.v.virtnum ~= 0 then return '' end

  if show_signs then
    local signs = get_signs(buf, vim.v.lnum)

    local git, other, dap
    for _, s in ipairs(signs) do
      if s.name and (s.name:find('GitSign', 1, true) or s.name:find('MiniDiffSign', 1, true)) then
        git = s
      elseif s.name and s.name:find('Dap', 1, true) then
        dap = s
      else
        other = s
      end
    end

    components[2] = icon(git)
    components[3] = icon(other)
    components[5] = icon(dap)
  end

  return table.concat(components, '')
end

return M
