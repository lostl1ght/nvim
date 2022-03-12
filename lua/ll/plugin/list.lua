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
        'NTBBloodbath/doom-one.nvim',
        config = function()
            require('ll.color.doom-one')
        end,
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
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('ll.plugin.config.gitsigns')
        end,
    },
    { 'iamcco/markdown-preview.nvim', run = ':call mkdp#util#install()' },
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
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
        },
        config = function()
            require('ll.lang.completion')
        end,
    },
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
    { 'ggandor/lightspeed.nvim' },
}
