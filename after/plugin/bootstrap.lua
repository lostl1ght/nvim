if vim.g.bootstrapping then
  vim.cmd('MasonInstall tree-sitter-cli')

  -- stylua: ignore
  require('nvim-treesitter').install({
    'bash', 'c', 'lua', 'luadoc', 'luap', 'markdown', 'markdown_inline',
    'query', 'regex', 'vim', 'vimdoc', 'gitattributes', 'gitcommit',
    'gitignore', 'git_config', 'git_rebase', 'json', 'toml', 'yaml',
    'go', 'gomod', 'gosum', 'gowork', 'python', 'rust', 'make'
  }, { summary = true }):wait(150000)

  vim.cmd('KanagawaCompile')

  vim.g.bootstrapping = false
end
