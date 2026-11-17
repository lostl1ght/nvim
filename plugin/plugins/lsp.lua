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

  vim.pack.add({
    gh('neovim/nvim-lspconfig'),
    gh('williamboman/mason.nvim'),
  }, { confirm = false })

  require('mason').setup({
    ui = {
      border = vim.g.border,
      width = 0.8,
      height = 0.8,
    },
  })
  vim.pack.add({ gh('williamboman/mason-lspconfig.nvim') }, { confirm = false })

  require('mason-lspconfig').setup({ automatic_enable = { exclude = { 'ruff' } } })
end)

safely('now', function()
  vim.pack.add({
    gh('folke/lazydev.nvim'),
    gh('Bilal2453/luvit-meta'),
  }, { confirm = false })

  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'Lazy%a' } },
      { path = 'mini.misc', words = { 'safely' } },
    },
  })
end)

safely('later', function() require('lightbulb').setup_au() end)
