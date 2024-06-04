return {
  'echasnovski/mini.bufremove',
  keys = {
    {
      '<leader>bd',
      function()
        require('mini.bufremove').delete()
      end,
      desc = 'Delete',
    },
    {
      '<leader>bD',
      function()
        require('mini.bufremove').delete(nil, true)
      end,
      desc = 'Force delete',
    },
    {
      '<leader>bu',
      function()
        require('mini.bufremove').unshow()
      end,
      desc = 'Unshow',
    },
  },
  config = function()
    require('mini.bufremove').setup()
  end,
}
