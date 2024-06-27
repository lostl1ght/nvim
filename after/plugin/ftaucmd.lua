local function au(ft, cb)
  local opts = {
    pattern = ft,
    callback = cb,
  }
  vim.api.nvim_create_autocmd('FileType', opts)
end

au('gitsigns.blame', function(data)
  local bufnr = data.buf
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_cmd({ cmd = 'bdelete', args = { bufnr } }, {})
  end, { buffer = bufnr })
end)

au({ 'c', 'cpp' }, function(data)
  vim.api.nvim_set_option_value('commentstring', '// %s', { buf = data.buf })
end)

au('go', function(data)
  vim.api.nvim_set_option_value('expandtab', false, { buf = data.buf })
end)

au('git', function(data)
  local bufnr = data.buf
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_cmd({ cmd = 'bdelete', args = { bufnr } }, {})
  end, { buffer = bufnr })
end)

au('help', function(data)
  local bufnr = data.buf
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_cmd({ cmd = 'bdelete', args = { bufnr } }, {})
  end, { buffer = bufnr })
  vim.cmd.wincmd('L')
end)

au({ 'lua', 'tex' }, function(data)
  vim.api.nvim_set_option_value('shiftwidth', 2, { buf = data.buf })
end)
