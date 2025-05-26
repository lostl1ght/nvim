return {
  settings = {
    Lua = {
      completion = { autoRequire = false, keywordSnippet = 'Disable' },
      diagnostics = {
        disable = { 'trailing-space', 'missing-fields' },
        unusedLocalExclude = { '_*' },
      },
      hint = {
        enable = true,
      },
      runtime = {
        pathStrict = true,
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
      },
      doc = {
        privateName = { '^_' },
      },
    },
  },
}
