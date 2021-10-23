local present, packer = pcall(require, 'plugin.packer')


if not present then
   return false
end

require('packer_compiled')

    -- Plugins
return packer.startup({function()
        -- Package manager
    use {'wbthomason/packer.nvim',}
        -- Cache
    use {'lewis6991/impatient.nvim',}
        -- Key bindings
    use {'folke/which-key.nvim',}

--[[ Style ]]--
        -- Theme
    use {'marko-cerovac/material.nvim',}
        -- Statusline
    use {
        'famiu/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
        -- Tabline
    --[[ use {
        'alvarosevilla95/luatab.nvim',
        requires='kyazdani42/nvim-web-devicons'
    } ]]
        -- Color highlighter
    use {'norcalli/nvim-colorizer.lua',}

--[[ Language servers ]]--
        -- Built-in LSP client
    use {'neovim/nvim-lspconfig',}
        -- Signature help
    use {'ray-x/lsp_signature.nvim',}

--[[ Debuggers ]]--
        -- DAP client
    use {'mfussenegger/nvim-dap',}
        -- Debugger UI
    use {'rcarriga/nvim-dap-ui',}
        -- Python adapter
    use {'mfussenegger/nvim-dap-python',}

--[[ Tools ]]--
        -- Tmux integration
    use {'aserowy/tmux.nvim',}
        -- Move faster
    use {'phaazon/hop.nvim',}
        -- Git decorations
    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }
        -- Markdown preview
    use {
        'iamcco/markdown-preview.nvim',
        run = ':call mkdp#util#install()'
    }
        -- Database integration
    use {
        'kristijanhusak/vim-dadbod-ui',
        requires = 'tpope/vim-dadbod'
    }
        -- IPython
    use {
        'hanschen/vim-ipython-cell',
        requires = 'jpalardy/vim-slime'
    }
        -- Starting screen
    use {'goolord/alpha-nvim',}
    -- use {'glepnir/dashboard-nvim',}
        -- Session manager
    use {
        'Shatur/neovim-session-manager',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        }
    }
        -- Git client
    use {
        'kdheepak/lazygit.nvim',
        config = function ()
            vim.g.lazygit_floating_window_use_plenary = 1
            vim.g.lazygit_use_neovim_remote = 1
            vim.env.GIT_EDITOR = "nvr --remote-wait +'set bufhidden=wipe'"
        end
    }

-- File management
        -- File tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }
        -- File searcher
    use {
        'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }

-- Syntax
        -- Gas syntax
    use {'Shirk/vim-gas',}
        -- Other
    use {'nvim-treesitter/nvim-treesitter',}

-- Completion
        -- Autocompletion plugin
    use {'hrsh7th/nvim-cmp',}
        -- LSP source for cmp
    use {'hrsh7th/cmp-nvim-lsp',}
        -- Buffer completion
    use {'hrsh7th/cmp-buffer',}
        -- Snippets source for cmp
    use {'saadparwaiz1/cmp_luasnip',}
        -- Snippets plugin
    use {'L3MON4D3/LuaSnip',}
        -- SQL completion
    use {
        'kristijanhusak/vim-dadbod-completion',
        requires = 'tpope/vim-dadbod'
    }
        -- Neovim api completion
    use {'hrsh7th/cmp-nvim-lua',}
        -- Path completion
    use {'hrsh7th/cmp-path',}
        -- Icons for cmp
    use {'onsails/lspkind-nvim',}
        -- Comit UI
    use {'rhysd/committia.vim',}

--[[ Format ]]--
    use {'mhartington/formatter.nvim',}
    use {'godlygeek/tabular',}
    use {'b3nj5m1n/kommentary',}

end})

