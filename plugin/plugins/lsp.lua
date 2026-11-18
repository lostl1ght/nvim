safely('now', function()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active
      if kind == 'update' or kind == 'install' then
        if name == 'mason.nvim' then
          if not active then vim.cmd.packadd('mason.nvim') end
          vim.cmd('MasonUpdate')
        end
      end
    end,
    desc = 'Update mason',
  })

  packadd({ 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' })

  require('mason').setup({
    ui = {
      border = vim.g.border,
      width = 0.8,
      height = 0.8,
    },
  })
  packadd({ 'williamboman/mason-lspconfig.nvim' }, { confirm = false })

  require('mason-lspconfig').setup({ automatic_enable = { exclude = { 'ruff' } } })
end)

safely('now', function()
  packadd({ 'folke/lazydev.nvim', 'Bilal2453/luvit-meta' })

  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'Lazy%a' } },
      { path = 'mini.misc', words = { 'safely' } },
    },
  })
end)

safely('later', function() require('lightbulb').setup_au() end)
