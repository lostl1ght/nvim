require('packer_compiled')
    -- Plugins
return require('packer').startup({function()
        -- Package manager
    use {
        'wbthomason/packer.nvim'
    }
        -- Key bindings
    use {
        'folke/which-key.nvim',
    }
    use {
        'lewis6991/impatient.nvim',
    }

--[[ Style ]]--
        -- Statusline
    use {
        'hoob3rt/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
        -- Theme
    use {
        'marko-cerovac/material.nvim'
    }
        -- Color highlighter
    use {
        'norcalli/nvim-colorizer.lua'
    }

    use {
        'alvarosevilla95/luatab.nvim',
        requires='kyazdani42/nvim-web-devicons'
    }

--[[ Language servers ]]--
        -- Built-in LSP client
    use {
        'neovim/nvim-lspconfig'
    }
        -- Signature help
    use {
        'ray-x/lsp_signature.nvim'
    }

--[[ Debuggers ]]--
        -- DAP client
    use {
        'mfussenegger/nvim-dap',
    }
        -- Debugger UI
    use {
        'rcarriga/nvim-dap-ui',
    }
        -- Python adapter
    use {
        'mfussenegger/nvim-dap-python',
    }

--[[ Tools ]]--
        -- Tmux integration
    use {
        'aserowy/tmux.nvim'
    }
        -- Move faster
    use {
        'phaazon/hop.nvim'
    }
        -- Git decorations
    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }
        -- Magit for neovim
    use {
        'TimUntersberger/neogit',
        requires = 'nvim-lua/plenary.nvim'
    }
        -- Terminal
    use {
        'akinsho/toggleterm.nvim'
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
    use {
        'glepnir/dashboard-nvim'
    }
        -- Session manager
    use {
        'Shatur/neovim-session-manager',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        }
    }
        -- Diff tool
    use {
        'sindrets/diffview.nvim'
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
    use {
        'Shirk/vim-gas'
    }
        -- Other
    use {
        'nvim-treesitter/nvim-treesitter'
    }

-- Completion
        -- Autocompletion plugin
    use {
        'hrsh7th/nvim-cmp'
    }
        -- LSP source for nvim-cmp
    use {
        'hrsh7th/cmp-nvim-lsp'
    }
        -- Buffer completion
    use {
        'hrsh7th/cmp-buffer'
    }
        -- Snippets source for nvim-cmp
    use {
        'saadparwaiz1/cmp_luasnip'
    }
        -- Snippets plugin
    use {
        'L3MON4D3/LuaSnip'
    }
        -- SQL completion
    use {
        'kristijanhusak/vim-dadbod-completion',
        requires = 'tpope/vim-dadbod'
    }
        -- Comit UI
    use {
        'rhysd/committia.vim'
    }

--[[ Format ]]--
    use {
        'mhartington/formatter.nvim'
    }
    use 'tami5/lspsaga.nvim'

end,
config = {
    display = {
        open_fn = require('packer.util').float,
    },
    compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    git = {
        clone_timeout = 180,
    },
}})
