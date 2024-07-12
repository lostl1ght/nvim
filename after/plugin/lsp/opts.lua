local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  local bufnr = data.buf
  if not client then return end
  -- client.server_capabilities.semanticTokensProvider = nil
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup('LspCursor', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspOptions', {}),
})
