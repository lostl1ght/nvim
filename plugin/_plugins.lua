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
    gh('echasnovski/mini.icons'),
    gh('rebelot/kanagawa.nvim'),
    gh('rebelot/heirline.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('HiPhish/rainbow-delimiters.nvim'),
    gh('williamboman/mason.nvim'),
    gh('williamboman/mason-lspconfig.nvim'),
    gh('neovim/nvim-lspconfig'),
    gh('folke/lazydev.nvim'),
    gh('Bilal2453/luvit-meta'),
    gh('echasnovski/mini.clue'),
    gh('echasnovski/mini.files'),
    { src = gh('lostl1ght/flatten.nvim'), version = 'develop' },
  })
end)

safely(
  'later',
  function()
    vim.pack.add({
      gh('echasnovski/mini.icons'),
      gh('echasnovski/mini.pick'),
      gh('echasnovski/mini.ai'),
      gh('echasnovski/mini.align'),
      gh('echasnovski/mini.bracketed'),
      gh('echasnovski/mini.bufremove'),
      gh('folke/ts-comments.nvim'),
      gh('echasnovski/mini.comment'),
      gh('echasnovski/mini.move'),
      gh('echasnovski/mini.surround'),
      gh('echasnovski/mini.hipatterns'),
      gh('echasnovski/mini.trailspace'),
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
