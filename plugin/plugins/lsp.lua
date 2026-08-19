safely(
  'now',
  function()
    require('mason').setup({
      ui = {
        border = vim.g.border,
        width = 0.8,
        height = 0.8,
      },
    })
  end
)

safely(
  'now',
  function() require('mason-lspconfig').setup({ automatic_enable = { exclude = { 'ruff' } } }) end
)
safely(
  'now',
  function()
    require('lazydev').setup({
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'lazy.nvim', words = { 'Lazy%a' } },
        { path = 'mini.misc', words = { 'safely' } },
      },
    })
  end
)

safely('later', function() require('lightbulb').setup_au() end)
