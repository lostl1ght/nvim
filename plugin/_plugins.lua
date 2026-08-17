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
    'https://github.com/echasnovski/mini.icons',
    'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/rebelot/heirline.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/HiPhish/rainbow-delimiters.nvim',
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/williamboman/mason-lspconfig.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/Bilal2453/luvit-meta',
    'https://github.com/echasnovski/mini.clue',
    'https://github.com/echasnovski/mini.files',
    { src = 'https://github.com/lostl1ght/flatten.nvim', version = 'develop' },
  })
end)

safely(
  'later',
  function()
    vim.pack.add({
      'https://github.com/echasnovski/mini.icons',
      'https://github.com/echasnovski/mini.pick',
      'https://github.com/echasnovski/mini.ai',
      'https://github.com/echasnovski/mini.align',
      'https://github.com/echasnovski/mini.bracketed',
      'https://github.com/echasnovski/mini.bufremove',
      'https://github.com/folke/ts-comments.nvim',
      'https://github.com/echasnovski/mini.comment',
      'https://github.com/echasnovski/mini.move',
      'https://github.com/echasnovski/mini.surround',
      'https://github.com/echasnovski/mini.hipatterns',
      'https://github.com/echasnovski/mini.trailspace',
      'https://github.com/saghen/blink.lib',
      'https://github.com/saghen/blink.cmp',
      'https://github.com/windwp/nvim-autopairs',
      'https://github.com/stevearc/conform.nvim',
      'https://github.com/folke/flash.nvim',
      'https://github.com/lewis6991/gitsigns.nvim',
      'https://github.com/kawre/neotab.nvim',
      'https://github.com/mfussenegger/nvim-lint',
      'https://github.com/folke/persistence.nvim',
      'https://github.com/folke/snacks.nvim',
      'https://github.com/m-demare/hlargs.nvim',
      'https://github.com/nvim-treesitter/nvim-treesitter-context',
      'https://github.com/folke/trouble.nvim',
    })
  end
)
