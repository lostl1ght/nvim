pcall(require, 'packer_compiled')
    -- Plugins
return {
    {'wbthomason/packer.nvim',},
    {'lewis6991/impatient.nvim',},
    {'folke/which-key.nvim',},

    {'marko-cerovac/material.nvim',
        config = function ()
            require('mars.color.material')
        end,
    },
    {'famiu/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function ()
            require('mars.color.feline')
        end
    },
    {'akinsho/bufferline.nvim',
        requires='kyazdani42/nvim-web-devicons',
        config = function ()
            vim.o.termguicolors = true
            require('bufferline').setup{}
        end
    },
    {'norcalli/nvim-colorizer.lua',
        config = function ()
            vim.o.termguicolors = true
            require('colorizer').setup()
        end,
    },

    {'neovim/nvim-lspconfig',},
    {'ray-x/lsp_signature.nvim',},

    {'mfussenegger/nvim-dap',
        requires = 'mfussenegger/nvim-dap-python',
    },
    {'rcarriga/nvim-dap-ui',},

    {'aserowy/tmux.nvim',},
    {'phaazon/hop.nvim',},
    {'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
    },
    {'iamcco/markdown-preview.nvim',
        run = ':call mkdp#util#install()'
    },
    {'kristijanhusak/vim-dadbod-ui',
        requires = 'tpope/vim-dadbod'
    },
    {'hanschen/vim-ipython-cell',
        requires = 'jpalardy/vim-slime',
    },
    {'goolord/alpha-nvim',},
    -- {'glepnir/dashboard-nvim',},
    {'Shatur/neovim-session-manager',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
    },
    {'kdheepak/lazygit.nvim',
        config = function ()
            vim.g.lazygit_floating_window_use_plenary = 1
            vim.g.lazygit_use_neovim_remote = 1
            vim.env.GIT_EDITOR = "nvr --remote-wait +'set bufhidden=wipe'"
        end
    },

    {'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    },
    {'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
    },

    {'Shirk/vim-gas',},
    {'nvim-treesitter/nvim-treesitter',},

    {'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
            'tpope/vim-dadbod',
            'kristijanhusak/vim-dadbod-completion',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
        },
    },
    {'hrsh7th/cmp-nvim-lsp',},
    {'L3MON4D3/LuaSnip',},
    {'onsails/lspkind-nvim',},

    {'rhysd/committia.vim',},

    {'mhartington/formatter.nvim',},
    {'godlygeek/tabular',},
    {'b3nj5m1n/kommentary',},

}
