local au = vim.api.nvim_create_autocmd

---@param name string
---@param clear boolean?
---@return integer
local aug = function(name, clear) return vim.api.nvim_create_augroup(name, { clear = clear }) end

au('FileType', {
  command = 'setlocal formatoptions-=cro',
  group = aug('FormatOptions'),
  desc = "Set 'formatoptions'",
})

au('TextYankPost', {
  callback = function() vim.hl.on_yank({ higroup = 'YankHighlight', timeout = 350 }) end,
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
    pcall(vim.treesitter.start, data.buf)
  end,
  group = aug('TreesitterHighlight'),
  desc = 'Enable treesitter highlight',
})

---@param ft string
---@param query string
---@return boolean
local check_query = function(ft, query)
  return vim.treesitter.language.get_lang(ft) ~= nil and vim.treesitter.query.get(ft, query) ~= nil
end

au('BufEnter', {
  callback = function()
    if vim.bo.buftype ~= '' then return end
    if check_query(vim.bo.filetype, 'folds') then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    else
      vim.wo.foldmethod = 'manual'
    end
  end,
  group = aug('TreesitterFold'),
  desc = 'Set treesitter fold expr',
})

au({ 'BufRead', 'BufNewFile' }, {
  callback = function(ev)
    local f = vim.fn.fnamemodify(ev.file, ':~:.')
    if vim.bo[ev.buf].buftype == '' and vim.fn.filereadable(ev.file) == 1 and f ~= ev.file then
      vim.cmd('silent file ' .. f)
      if not vim.bo[ev.buf].readonly then vim.cmd('silent! write!') end
      vim.cmd('silent! edit!')
    end
  end,
  group = aug('RelativeFile'),
  desc = 'Make file name relative',
})

au('FileType', {
  group = aug('TreesitterIndent'),
  callback = function()
    if vim.bo.buftype ~= '' then return end
    if check_query(vim.bo.filetype, 'indents') then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
  desc = 'Enable treesitter indent',
})

au('LspAttach', {
  callback = function(data)
    local client = vim.lsp.get_client_by_id(data.data.client_id)
    if not client then return end
    local buf_id = data.buf
    if client.server_capabilities.inlayHintProvider then
      local group = aug('LspInlayHints', false)

      au('InsertEnter', {
        callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = buf_id }) end,
        buffer = buf_id,
        group = group,
        desc = 'Disable inlay hints on insert enter',
      })

      au('InsertLeave', {
        callback = function()
          vim.lsp.inlay_hint.enable(vim.b.inlay_hint_enabled or false, { bufnr = buf_id })
        end,
        buffer = buf_id,
        group = group,
        desc = 'Enable inlay hints on insert leave',
      })
    end

    if client.server_capabilities.documentHighlightProvider then
      local group = aug('LspCursor', false)
      au({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
        callback = vim.lsp.buf.document_highlight,
        buffer = buf_id,
        group = group,
        desc = 'Enable references highlighting',
      })
      au({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
        callback = vim.lsp.buf.clear_references,
        buffer = buf_id,
        group = group,
        desc = 'Clear references',
      })
    end

    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = vim.g.border }) end, {
        buffer = buf_id,
        desc = 'LSP hover',
      })
    end
  end,
  group = aug('LspOptions'),
  desc = 'Setup LSP highlight & inlay hints',
})

au('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value
    if value.kind == 'begin' then
      vim.api.nvim_ui_send('\027]9;4;1;0\027\\')
    elseif value.kind == 'end' then
      vim.api.nvim_ui_send('\027]9;4;0\027\\')
    elseif value.kind == 'report' then
      vim.api.nvim_ui_send(string.format('\027]9;4;1;%d\027\\', value.percentage or 0))
    end
  end,
  group = aug('LspProgress'),
  desc = 'Show LSP progress as OSC 9;4',
})
