local function callback(data)
  local keys = {
    {
      'gr',
      vim.lsp.buf.rename,
      desc = 'Rename',
    },
    {
      '<leader>ti',
      function()
        local new_state = not vim.lsp.inlay_hint.is_enabled({bufnr = 0})
        vim.lsp.inlay_hint.enable(new_state)
        local msg = 'inlay hints ' .. (new_state and 'enabled' or 'disabled')
        vim.notify(msg, vim.log.levels.INFO, { title = 'Lsp' })
      end,
      desc = 'Inlay hints',
    },
    {
      '<leader>td',
      function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end,
      desc = 'Diagnostics',
    },
  }

  local wkopts = {
    prefix = {
      key = '<leader>c',
      name = 'code',
    },
  }
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local util = require('util')
  for _, map in ipairs(keys) do
    util.keymap_set(map, data.buf)
  end

  if client.server_capabilities.codeActionProvider then
    util.keymap_set({
      '<leader>ca',
      vim.lsp.buf.code_action,
      mode = { 'n', 'v' },
      desc = 'Code actions',
    }, data.buf, wkopts)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspGeneralKeys', {}),
})
