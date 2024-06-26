---@type LazyPluginSpec
return {
  'lostl1ght/lazygit.nvim',
  cmd = 'Lg',
  keys = {
    {
      '<leader>g',
      function()
        require('lazygit').open()
      end,
      desc = 'Lazygit',
    },
  },
  dependencies = {
    'samjwill/nvim-unception',
    lazy = false,
    config = function()
      vim.env['GIT_EDITOR'] = "nvim --cmd 'let g:unception_block_while_host_edits=1'"
    end,
  },
}
