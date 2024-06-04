return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',
  dependencies = 'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'c',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'vim',
        'vimdoc',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
    vim.treesitter.language.register('bash', { 'sh', 'zsh' })
    vim.treesitter.language.register('jsonc', { 'json' })
  end,
}
