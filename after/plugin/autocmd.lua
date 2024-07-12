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
  callback = function()
    if vim.bo.buftype ~= '' then return end
    pcall(vim.treesitter.start)
  end,
  group = aug('TreesitterHighlight'),
  desc = 'Enable treesitter highlight',
})

au('FileType', {
  callback = function()
    if vim.bo.buftype ~= '' or vim.bo.filetype == 'minideps-confirm' then return end
    if vim.treesitter.query.get(vim.bo.filetype, 'folds') then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    else
      vim.wo.foldmethod = 'indent'
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
