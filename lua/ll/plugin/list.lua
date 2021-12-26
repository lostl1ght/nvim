pcall(require, 'packer_compiled')
return {
    { 'wbthomason/packer.nvim' },
    { 'lewis6991/impatient.nvim' },
    {
        'folke/which-key.nvim',
        config = function()
            require('ll.core.keymap')
        end,
    },
    {
        'marko-cerovac/material.nvim',
        config = function()
            require('ll.color.material')
        end,
        disable = llvim.theme ~= 'material',
    },
    {
        'Yagua/nebulous.nvim',
        config = function()
            require('ll.color.nebulous')
        end,
        disable = llvim.theme ~= 'nebulous',
    },
    {
        'famiu/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('ll.color.feline')
        end,
    },
    {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('ll.color.bufferline')
        end,
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            local present, color = pcall(require, 'colorizer')
            if not present then
                return print('colorizer not found')
            end
            vim.o.termguicolors = true
            color.setup()
        end,
    },
    {
        'neovim/nvim-lspconfig',
        requires = 'hrsh7th/cmp-nvim-lsp',
        config = function()
            require('ll.lang.server.ccls')
            require('ll.lang.server.pyright')
            require('ll.lang.server.sumneko')
            require('ll.lang.server.cmake')
            require('ll.lang.server.texlab')
            require('ll.lang.server.rust')
            require('ll.lang.server.gopls')
        end,
    },
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            local present, sign = pcall(require, 'lsp_signature')
            if not present then
                return print('lsp_signature not found')
            end
            sign.setup({
                hint_enable = false,
                bind = true,
                handler_opts = {
                    border = 'rounded',
                },
            })
        end,
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            require('ll.debug.codelldb')
        end,
    },
    {
        'mfussenegger/nvim-dap-python',
        requires = {
            'mfussenegger/nvim-dap',
        },
        config = function()
            require('ll.debug.python')
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
        },
        config = function()
            require('ll.debug.dapui')
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('ll.plugin.config.gitsigns')
        end,
    },
    { 'iamcco/markdown-preview.nvim', run = ':call mkdp#util#install()' },
    {
        'kristijanhusak/vim-dadbod-ui',
        requires = 'tpope/vim-dadbod',
        config = function()
            require('ll.plugin.config.sql')
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('ll.plugin.config.telescope')
        end,
    },
    {
        'Shatur/neovim-session-manager',
        requires = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('ll.plugin.config.session')
        end,
    },
    {
        'kdheepak/lazygit.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            vim.g.lazygit_floating_window_use_plenary = 1
            vim.g.lazygit_floating_window_scaling_factor = 0.8
            vim.env.GIT_EDITOR = "nvr --remote-wait +'set bufhidden=wipe'"
        end,
    },
    {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('ll.plugin.config.nvimtree')
        end,
    },
    {
        'Shirk/vim-gas',
        config = function()
            vim.cmd('au BufRead,BufNewFile *.s set ft=gas')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('ll.lang.treesitter')
        end,
    },
    {
        'hrsh7th/nvim-cmp',
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
        config = function()
            require('ll.lang.completion')
            require('ll.snippet')
        end,
    },
    { 'rhysd/committia.vim' },
    {
        'mhartington/formatter.nvim',
        config = function()
            require('ll.lang.format')
        end,
    },
    { 'godlygeek/tabular' },
    {
        'numToStr/Comment.nvim',
        config = function()
            local present, comment = pcall(require, 'Comment')
            if not present then
                return print('comment not found')
            end
            comment.setup({ ignore = '^$' })
        end,
    },
    {
        'knubie/vim-kitty-navigator',
        run = 'cp ./*.py ~/.config/kitty/',
    },
    {
        'folke/trouble.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('trouble').setup({})
        end,
    },
    {
        'catppuccin/nvim',
        as = 'catppuccin',
        config = function()
            require('ll.color.catppuccin')
        end,
        disable = llvim.theme ~= 'catppuccin',
    },
    -- {
    --     'ray-x/navigator.lua',
    --     requires = { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
    --     config = function()
    --         require('ll.lang.navigator')
    --     end,
    -- },
    { 'ggandor/lightspeed.nvim' },
    {
        'RishabhRD/nvim-lsputils',
        requires = { 'RishabhRD/popfix' },
        config = function()
            require('ll.lang.lsputils')
        end,
    },
}
