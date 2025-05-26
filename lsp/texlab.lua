local auxdir = 'build'
return {
  settings = {
    texlab = {
      auxDirectory = auxdir,
      bibtexFormatter = 'texlab',
      build = {
        executable = 'latexmk',
        args = {
          '-pdf',
          ('-output-directory=%s'):format(auxdir),
          ('-pdflatex="%s %s %s %%O %%S"'):format(
            '-interaction=nonstopmode',
            ('-aux-directory=%s'):format(auxdir),
            '-shell-escape'
          ),
          '%f',
        },
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false,
      },
      diagnosticsDelay = 300,
      diagnostics = { ignoredPatterns = { 'Undefined reference' } },
      formatterLineLength = 80,
      forwardSearch = { executable = 'xdg-open', args = { '%p' } },
      latexFormatter = 'latexindent',
      latexindent = {
        modifyLineBreaks = true,
        ['local'] = vim.fs.normalize(vim.fn.stdpath('config') .. '/indentconfig.yaml'),
      },
    },
  },
}
