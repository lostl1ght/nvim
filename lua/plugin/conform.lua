local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'stevearc/conform.nvim' })
  vim.keymap.set({ 'n', 'x' }, '<leader>cf', function()
    require('conform').format({
      async = true,
      lsp_format = 'fallback',
    }, function() vim.cmd('silent update') end)
  end, { desc = 'Format' })
  -- stylua: ignore
  require('conform.formatters.latexindent').args = {
    '-g', '/dev/null',
    '-m',
    '-l', vim.fs.normalize(vim.fn.stdpath('config') .. '/indentconfig.yaml'),
    '-',
  }
  require('conform.formatters.goimports').args = {
    '-srcdir',
    '$DIRNAME',
    '-local',
    'core-ovn',
  }
  require('conform').setup({
    formatters_by_ft = {
      bib = { 'latexindent' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      go = { 'gofumpt', --[['golines',]] 'goimports' },
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      tex = { 'latexindent' },
    },
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
    },
  })
end)
