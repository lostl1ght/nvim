local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local util = require('util')
  local set = util.keymap_set
  local mc = util.set_mini_clue

  set({
    'gr',
    vim.lsp.buf.rename,
    desc = 'Rename',
    buffer = data.buf,
  })
  set({
    '<leader>ci',
    function()
      local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
      vim.lsp.inlay_hint.enable(new_state, { bufnr = 0 })
      local msg = 'inlay hints ' .. (new_state and 'enabled' or 'disabled')
      vim.notify(msg, vim.log.levels.INFO, { title = 'Lsp' })
    end,
    desc = 'Inlay hints',
    buffer = data.buf,
  })
  set({
    '<leader>ct',
    function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    desc = 'Toggle diagnostics',
    buffer = data.buf,
  })

  mc({
    key = '<leader>c',
    name = 'code',
    buf = data.buf,
  })
  if client.server_capabilities.codeActionProvider then
    set({
      '<leader>ca',
      vim.lsp.buf.code_action,
      mode = { 'n', 'v' },
      desc = 'Code actions',
      buffer = data.buf,
    })
    mc({
      key = '<leader>c',
      name = 'code',
      buf = data.buf,
      mode = 'v',
    })
  end
  if client.server_capabilities.signatureHelpProvider then
    set({
      '<c-k>',
      function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.close()
        end
        vim.lsp.buf.signature_help()
      end,
      mode = 'i',
      buffer = data.buf,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspGeneralKeys', {}),
})
