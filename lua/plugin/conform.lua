local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'stevearc/conform.nvim' })
  -- stylua: ignore
  require('conform.formatters.latexindent').args = {
    '-g', '/dev/null',
    '-m',
    '-l', vim.fs.normalize(vim.fn.stdpath('config') .. '/indentconfig.yaml'),
    '-',
  }
  require('conform').setup({
    formatters_by_ft = {
      bib = { 'latexindent' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      go = { 'gofmt' },
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      tex = { 'latexindent' },
    },
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
    },
  })
  vim.go.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
