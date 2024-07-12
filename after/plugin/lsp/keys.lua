local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then return end

  local bufnr = data.buf
  local set = vim.keymap.set

  set('n', 'grn', vim.lsp.buf.rename, {
    desc = 'Rename',
    buffer = bufnr,
  })
  set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
    desc = 'Code action',
    buffer = bufnr,
  })
  set('n', '\\l', function()
    local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.b.inlay_hint_enabled = new_state
    vim.lsp.inlay_hint.enable(new_state, { bufnr = 0 })
    local msg = new_state and 'inlayhint' or 'noinlayhint'
    print(msg)
  end, {
    desc = 'Inlay hints',
    buffer = data.buf,
  })
  set('n', '\\t', function()
    local buf_id = vim.api.nvim_get_current_buf()
    local new_state = not vim.diagnostic.is_enabled({ bufnr = buf_id })
    vim.diagnostic.enable(new_state, { bufnr = buf_id })
    local msg = new_state and 'diagnostic' or 'nodiagnostic'
    print(msg)
  end, {
    desc = 'Diagnostics',
    buffer = bufnr,
  })
  set('n', ']e', function() require('util.goto').next(vim.v.count) end, {
    desc = 'Reference forward',
    buffer = bufnr,
  })
  set('n', '[e', function() require('util.goto').prev(vim.v.count) end, {
    desc = 'Reference backward',
    buffer = bufnr,
  })
  set('n', ']E', function() require('util.goto').last() end, {
    desc = 'Reference last',
    buffer = bufnr,
  })
  set('n', '[E', function() require('util.goto').first() end, {
    desc = 'Reference first',
    buffer = bufnr,
  })

  local ok, clue = pcall(require, 'mini.clue')
  if ok then
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) then clue.ensure_buf_triggers(bufnr) end
    end)
  end

  if client.server_capabilities.inlayHintProvider then
    local group = vim.api.nvim_create_augroup('ToggleInlayHints', { clear = false })

    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
    end, 500)

    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) end,
      buffer = bufnr,
      group = group,
      desc = 'Enable inlay hints',
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = function() vim.lsp.inlay_hint.enable(vim.b.inlay_hint_enabled, { bufnr = bufnr }) end,
      buffer = bufnr,
      group = group,
      desc = 'Disable inlay hints',
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspGeneralKeys', {}),
})
