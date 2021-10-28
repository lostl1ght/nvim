pcall(require, 'packer_compiled')
    -- Plugins
return {
    {'wbthomason/packer.nvim',},
    {'lewis6991/impatient.nvim',},
    {'folke/which-key.nvim',
        config = function ()
            require('ll.core.keymap')
        end,
    },

    {'marko-cerovac/material.nvim',
        config = function ()
            require('ll.color.material')
        end,
        disable = llvim.theme ~= 'material',
    },
    {'famiu/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function ()
            require('ll.color.feline')
        end,
    },
    {'akinsho/bufferline.nvim',
        requires='kyazdani42/nvim-web-devicons',
        config = function ()
            require('ll.color.bufferline')
        end,
    },
    {'norcalli/nvim-colorizer.lua',
        config = function ()
            local present, color = pcall(require, 'colorizer')
            if not present then
                return print('colorizer not found')
            end
            vim.o.termguicolors = true
            color.setup()
        end,
    },

    {'neovim/nvim-lspconfig',
        requires =  'hrsh7th/cmp-nvim-lsp',
        config = function ()
            require('ll.lang.server.ccls')
            require('ll.lang.server.pyright')
            require('ll.lang.server.sumneko')
            require('ll.lang.server.cmake')
            require('ll.lang.server.texlab')
            require('ll.lang.server.rust')
        end,
    },
    {'ray-x/lsp_signature.nvim',
        config = function ()
            local present, sign = pcall(require, 'lsp_signature')
            if not present then
                return print('lsp_signature not found')
            end
            sign.setup({hint_enable = false,})
        end,
    },

    {'mfussenegger/nvim-dap',
        config = function ()
            require('ll.debug.codelldb')
        end,
    },
    {'mfussenegger/nvim-dap-python',
        config = function ()
            require('ll.debug.python')
        end,
    },
    {'rcarriga/nvim-dap-ui',
        config = function ()
            require('ll.debug.dapui')
        end,
    },

    {'aserowy/tmux.nvim',
        config = function ()
            require('ll.plugin.config.tmux')
        end,
    },
    {'phaazon/hop.nvim',},
    {'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function ()
            require('ll.plugin.config.gitsigns')
        end,
    },
    {'iamcco/markdown-preview.nvim',
        run = ':call mkdp#util#install()'
    },
    {'kristijanhusak/vim-dadbod-ui',
        requires = 'tpope/vim-dadbod',
        config = function ()
            require('ll.plugin.config.sql')
        end,
    },
    {'hanschen/vim-ipython-cell',
        requires = 'jpalardy/vim-slime',
        config = function ()
            require('ll.plugin.config.ipython')
        end,
        disable = true,
    },
    {'goolord/alpha-nvim',
        config = function ()
            require('ll.plugin.config.alpha')
        end,
    },
    -- {'glepnir/dashboard-nvim',},
    {'nvim-telescope/telescope.nvim',
        config = function ()
            require('ll.plugin.config.telescope')
        end,
    },

    {'Shatur/neovim-session-manager',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function ()
            require('ll.plugin.config.session')
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
            require('ll.plugin.config.nvimtree')
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
            require('ll.lang.treesitter')
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
            require('ll.lang.completion')
            require('ll.snippet')
        end
    },

    {'rhysd/committia.vim',},

    {'mhartington/formatter.nvim',
        config = function ()
            require('ll.lang.format')
        end
    },
    {'godlygeek/tabular',},
    {'numToStr/Comment.nvim',
        config = function()
            local present, comment = pcall(require, 'Comment')
            if not present then
                return print('comment not found')
            end
            comment.setup()
        end
    }
}
