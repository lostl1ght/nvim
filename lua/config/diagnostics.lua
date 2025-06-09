if vim.g.vscode then return end

local s = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [s.ERROR] = 'e',
      [s.WARN] = 'w',
      [s.INFO] = 'i',
      [s.HINT] = 'h',
    },
  },
  float = { border = vim.g.border },
  virtual_text = false,
  severity_sort = true,
})
