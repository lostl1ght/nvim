local M = { 'lostl1ght/very-lazygit.nvim' }

M.cmd = 'Lg'

M.keys = {
  {
    '<leader>g',
    function()
      require('lazygit').open()
    end,
    desc = 'Lazygit',
  },
}

M.dependencies = {
  'samjwill/nvim-unception',
  lazy = false,
  config = function()
    vim.env['GIT_EDITOR'] = "nvim --cmd 'let g:unception_block_while_host_edits=1'"
  end,
}

return M
