return {
  'nvim-treesitter/nvim-treesitter-context',
  keys = {
    {
      '<leader>tc',
      function()
        vim.cmd({ cmd = 'TSContextToggle' })
      end,
      desc = 'Context',
    },
  },
  config = function()
    require('treesitter-context').setup({
      enable = false,
    })
  end,
}
