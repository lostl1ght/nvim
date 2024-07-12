local au = vim.api.nvim_create_autocmd

---@param name string
---@return integer
local aug = function(name) return vim.api.nvim_create_augroup(name, {}) end

au('TextYankPost', {
  callback = function() vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 350 }) end,
  group = aug('YankHighlight'),
  desc = 'Setup yank highlight',
})

au('TermOpen', {
  callback = function()
    vim.wo.scrolloff = 0
    vim.wo.sidescrolloff = 0
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
  group = aug('TermOptions'),
  desc = 'Set some options for terminal',
})

au('BufRead', {
  callback = function()
    if vim.bo.readonly then vim.bo.modifiable = false end
  end,
  group = aug('BufModifiable'),
  desc = "Set 'noma' for 'ro' files",
})

au('FileType', {
  callback = function(data)
    if vim.bo.buftype ~= '' then return end
    local bufnr = data.buf
    local started = pcall(vim.treesitter.start, bufnr)
    if started then
      local ok, rd = pcall(require, 'rainbow-delimiters')
      if ok then pcall(rd.enable, bufnr) end
    end
  end,
  group = aug('TreesitterHighlight'),
  desc = 'Enable treesitter highlight',
})

au('FileType', {
  callback = function()
    if vim.bo.buftype ~= '' then return end
    if vim.treesitter.query.get(vim.bo.filetype, 'folds') then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
  group = aug('TreesitterFold'),
  desc = 'Set treesitter fold expr',
})

au('FileType', {
  callback = function()
    if vim.bo.buftype ~= '' then return end
    if vim.treesitter.query.get(vim.bo.filetype, 'indents') then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
  group = aug('TreesitterIndent'),
  desc = 'Enable treesitter indent',
})

au('LspAttach', {
  callback = function(data)
    local client = vim.lsp.get_client_by_id(data.data.client_id)
    if not client then return end
    local bufnr = data.buf
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
        callback = function()
          vim.lsp.inlay_hint.enable(vim.b.inlay_hint_enabled, { bufnr = bufnr })
        end,
        buffer = bufnr,
        group = group,
        desc = 'Disable inlay hints',
      })
    end
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
  end,
  group = aug('LspOptions'),
  desc = 'Setup LSP highlight & inlay hints',
})
