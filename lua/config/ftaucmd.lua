---@param ft string|string[]
---@param cb function
local function au(ft, cb)
  local opts = {
    pattern = ft,
    callback = cb,
  }
  vim.api.nvim_create_autocmd('FileType', opts)
end

au({ 'gitsigns-blame', 'help', 'qf' }, function(data)
  local buf = data.buf
  -- stylua: ignore
  vim.keymap.set('n', 'q',
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_cmd({ cmd = 'bwipeout', args = { buf } }, {})
      end
    end),
    { buffer = buf }
  )
end)

au('qf', function() vim.bo.buflisted = false end)

au('go', function() vim.bo.expandtab = false end)

au({ 'help', 'man' }, function(data)
  local winid = vim.fn.bufwinid(data.buf)
  vim.fn.win_execute(winid, 'noautocmd wincmd L')
end)

au({ 'lua', 'tex' }, function() vim.bo.shiftwidth = 2 end)

au('noice', function(data)
  local ok, clue = pcall(require, 'mini.clue')
  if ok then
    local buf = data.buf
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then clue.ensure_buf_triggers(buf) end
    end)
  end
end)
