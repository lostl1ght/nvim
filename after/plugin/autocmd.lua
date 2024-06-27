local au = vim.api.nvim_create_autocmd

au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 350 })
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', {}),
  desc = 'Setup yank highlight',
})

au('TermOpen', {
  callback = function()
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  group = vim.api.nvim_create_augroup('TermOptions', {}),
  desc = 'Set some options for terminal',
})

au('BufRead', {
  callback = function()
    if vim.bo.readonly then
      vim.bo.modifiable = false
    end
  end,
  group = vim.api.nvim_create_augroup('BufModifiable', {}),
  desc = "Set 'noma' for 'readonly' files",
})
