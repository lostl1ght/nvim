pcall(require, 'packer_compiled')
    -- Plugins
return {
    {'wbthomason/packer.nvim',},
    {'lewis6991/impatient.nvim',},
    {'folke/which-key.nvim',
        config = function ()
            require('lostlight.core.keymap')
        end,
    },

    {'marko-cerovac/material.nvim',
        config = function ()
            require('lostlight.color.material')
        end,
    },
    {'famiu/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function ()
            require('lostlight.color.feline')
        end,
    },
    {'akinsho/bufferline.nvim',
        requires='kyazdani42/nvim-web-devicons',
        config = function ()
            local present, line = pcall(require, 'bufferline')
            if not present then
                return
            end
            vim.o.termguicolors = true
            line.setup{}
        end,
    },
    {'norcalli/nvim-colorizer.lua',
        config = function ()
            local present, color = pcall(require, 'colorizer')
            if not present then
                return
            end
            vim.o.termguicolors = true
            color.setup()
        end,
    },

    {'neovim/nvim-lspconfig',
        requires =  'hrsh7th/cmp-nvim-lsp',
        config = function ()
            require('lostlight.lang.server.ccls')
            require('lostlight.lang.server.pyright')
            require('lostlight.lang.server.sumneko')
            require('lostlight.lang.server.cmake')
            require('lostlight.lang.server.texlab')
            require('lostlight.lang.server.rust')
        end,
    },
    {'ray-x/lsp_signature.nvim',
        config = function ()
            local present, sign = pcall(require, 'lsp_signature')
            if not present then
                return
            end
            sign.setup({hint_enable = false,})
        end
    },

    {'mfussenegger/nvim-dap',
        config = function ()
            require('lostlight.debugger.codelldb')
        end,
    },
    {'mfussenegger/nvim-dap-python',
        config = function ()
            require('lostlight.debugger.python')
        end,
    },
    {'rcarriga/nvim-dap-ui',
        config = function ()
            require('lostlight.debugger.dapui')
        end,
    },

    {'aserowy/tmux.nvim',
        config = function ()
            require('lostlight.plugin.config.tmux')
        end,
    },
    {'phaazon/hop.nvim',},
    {'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function ()
            require('lostlight.plugin.config.gitsigns')
        end,
    },
    {'iamcco/markdown-preview.nvim',
        run = ':call mkdp#util#install()'
    },
    {'kristijanhusak/vim-dadbod-ui',
        requires = 'tpope/vim-dadbod',
        config = function ()
            require('lostlight.plugin.config.sql')
        end,
    },
    -- {'hanschen/vim-ipython-cell',
    --     requires = 'jpalardy/vim-slime',
    --     config = function ()
    --         require('lostlight.plugin.config.ipython')
    --     end,
    -- },
    {'goolord/alpha-nvim',
        config = function ()
            require('lostlight.plugin.config.alpha')
        end,
    },
    -- {'glepnir/dashboard-nvim',},
    {'nvim-telescope/telescope.nvim',
        config = function ()
            require('lostlight.plugin.config.telescope')
        end,
    },
            
    {'Shatur/neovim-session-manager',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function ()
            require('lostlight.plugin.config.session')
        end,
    },
    {'kdheepak/lazygit.nvim',
        config = function ()
            vim.g.lazygit_floating_window_use_plenary = 1
            vim.g.lazygit_use_neovim_remote = 1
            vim.env.GIT_EDITOR = "nvr --remote-wait +'set bufhidden=wipe'"
        end
    },

    {'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function ()
            require('lostlight.plugin.config.nvimtree')
        end,
    },

    {'Shirk/vim-gas',
        config = function ()
            local cmd = vim.cmd
            cmd 'au BufRead,BufNewFile *.ASM set ft=masm'
            cmd 'au BufRead,BufNewFile *.asm set ft=masm'
            cmd 'au BufRead,BufNewFile *.s set ft=gas'
        end,
    },
    {'nvim-treesitter/nvim-treesitter',
        config = function ()
            require('lostlight.lang.treesitter')
        end
    },

    {'hrsh7th/nvim-cmp',
        requires = {
            'L3MON4D3/LuaSnip',
            'onsails/lspkind-nvim',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-buffer',
            'tpope/vim-dadbod',
            'kristijanhusak/vim-dadbod-completion',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function ()
            require('lostlight.lang.completion')
            require('lostlight.snippet')
        end
    },

    {'rhysd/committia.vim',},

    {'mhartington/formatter.nvim',
        config = function ()
            require('lostlight.lang.format.clang')
        end
    },
    {'godlygeek/tabular',},
    {'b3nj5m1n/kommentary',},
}
