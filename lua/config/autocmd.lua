if vim.g.vscode then return end

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
  return pcall(vim.treesitter.get_parser) and vim.treesitter.query.get(ft, query) ~= nil
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

      --[[
      vim.defer_fn(function()
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = buf_id })
      end, 500)
      ]]
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

    --[[
    -- FIXME: breaks neovim
    if client.server_capabilities.codeLensProvider then
      local group = aug('LspCodeLens', false)
      au({ 'InsertLeave', 'BufEnter' }, {
        callback = function(d) vim.lsp.codelens.refresh({ bufnr = d.buf }) end,
        buffer = buf_id,
        group = group,
        desc = 'Refresh code lens'
      })
    end
    ]]
  end,
  group = aug('LspOptions'),
  desc = 'Setup LSP highlight & inlay hints',
})
