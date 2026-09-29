safely('now', function()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active
      if kind == 'update' or kind == 'install' then
        if name == 'nvim-treesitter' then
          if not active then vim.cmd.packadd('nvim-treesitter') end
          vim.cmd('TSUpdate')
        end

        if name == 'mason.nvim' then
          if not active then vim.cmd.packadd('mason.nvim') end
          vim.cmd('MasonUpdate')
        end

        if name == 'blink.cmp' then
          if not active then
            vim.cmd.packadd('blink.lib')
            vim.cmd.packadd('blink.cmp')
          end
          require('blink.cmp').build()
        end
      end
    end,
    desc = 'Post install actions for Pack',
  })
  -- TSInstall bash c lua luadoc luap markdown markdown_inline query regex vim vimdoc gitattributes gitcommit gitignore git_config git_rebase json toml yaml go gomod gosum gowork python rust make
  vim.pack.add({
    gh('nvim-mini/mini.icons'),
    gh('rebelot/kanagawa.nvim'),
    gh('rebelot/heirline.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('HiPhish/rainbow-delimiters.nvim'),
    gh('williamboman/mason.nvim'),
    gh('williamboman/mason-lspconfig.nvim'),
    gh('neovim/nvim-lspconfig'),
    gh('folke/lazydev.nvim'),
    gh('Bilal2453/luvit-meta'),
    gh('nvim-mini/mini.clue'),
    gh('nvim-mini/mini.files'),
    { src = gh('lostl1ght/flatten.nvim'), version = 'develop' },
  })
end)

safely(
  'later',
  function()
    vim.pack.add({
      gh('nvim-mini/mini.icons'),
      gh('nvim-mini/mini.pick'),
      gh('nvim-mini/mini.ai'),
      gh('nvim-mini/mini.align'),
      gh('nvim-mini/mini.bracketed'),
      gh('nvim-mini/mini.bufremove'),
      gh('folke/ts-comments.nvim'),
      gh('nvim-mini/mini.comment'),
      gh('nvim-mini/mini.move'),
      gh('nvim-mini/mini.surround'),
      gh('nvim-mini/mini.hipatterns'),
      gh('nvim-mini/mini.trailspace'),
      gh('saghen/blink.lib'),
      gh('saghen/blink.cmp'),
      gh('windwp/nvim-autopairs'),
      gh('stevearc/conform.nvim'),
      gh('folke/flash.nvim'),
      gh('lewis6991/gitsigns.nvim'),
      gh('kawre/neotab.nvim'),
      gh('mfussenegger/nvim-lint'),
      gh('folke/persistence.nvim'),
      gh('folke/snacks.nvim'),
      gh('m-demare/hlargs.nvim'),
      gh('nvim-treesitter/nvim-treesitter-context'),
      gh('folke/trouble.nvim'),
    })
  end
)
