vim.treesitter.language.register('bash', { 'sh', 'zsh' })
vim.filetype.add({
  extension = {
    h = 'cpp',
    just = 'just',
    Justfile = 'just',
    justfile = 'just',
    ovsschema = 'json',
    tex = 'tex',
  },
  filename = {
    ['.clang-format'] = 'yaml',
    ['.clangd'] = 'yaml',
    ['.zimrc'] = 'zsh',
    Justfile = 'just',
    justfile = 'just',
  },
  pattern = {
    ['.*/tmux/.*%.conf'] = 'tmux',
  },
})
