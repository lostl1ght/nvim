local function callback(data)
  local keys = {
    {
      'gr',
      vim.lsp.buf.rename,
      desc = 'Rename',
      buffer = data.buf,
    },
    {
      '<leader>ci',
      function()
        local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(new_state, { bufnr = 0 })
        local msg = 'inlay hints ' .. (new_state and 'enabled' or 'disabled')
        vim.notify(msg, vim.log.levels.INFO, { title = 'Lsp' })
      end,
      desc = 'Inlay hints',
      buffer = data.buf,
    },
    {
      '<leader>ct',
      function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end,
      desc = 'Toggle diagnostics',
      buffer = data.buf,
    },
  }

  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local util = require('util')
  for _, map in ipairs(keys) do
    util.keymap_set(map)
  end
  local opts = {
    key = '<leader>c',
    name = 'code',
    buf = data.buf,
  }
  util.set_which_key(opts)

  if client.server_capabilities.codeActionProvider then
    util.keymap_set({
      '<leader>ca',
      vim.lsp.buf.code_action,
      mode = { 'n', 'v' },
      desc = 'Code actions',
      buffer = data.buf,
    })
    util.set_which_key({
      key = '<leader>c',
      name = 'code',
      buf = data.buf,
      mode = { 'n', 'v' },
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspGeneralKeys', {}),
})
