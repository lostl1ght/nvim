return {
  'stevearc/conform.nvim',

  keys = {
    {
      'gf',
      function()
        require('conform').format({
          async = true,
          lsp_format = 'fallback',
        }, function()
          vim.cmd({ cmd = 'update', mods = { silent = true } })
        end)
      end,
      desc = 'Format',
      mode = { 'n', 'v' },
    },
  },

  config = function()
    require('conform.formatters.latexindent').args = {
      '-g',
      '/dev/null',
      '-m',
      '-l',
      vim.fs.normalize(vim.fn.stdpath('config') .. '/latexindent/indentconfig.yaml'),
      '-',
    }
    require('conform.formatters.rustfmt').args = {
      '--emit=stdout',
      '--edition=2021',
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
    })
  end,
}
