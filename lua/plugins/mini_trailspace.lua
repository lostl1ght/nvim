return {
  'echasnovski/mini.trailspace',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>tw',
      function()
        vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable
        require('mini.trailspace').highlight()
        local state = vim.b.minitrailspace_disable and 'disabled' or 'enabled'
        vim.notify(('trailspace highlight %s'):format(state))
      end,
      desc = 'Trailspace highlight',
    },
    --[[
  {
    '<leader>cw',
    function()
      require('mini.trailspace').trim()
    end,
    desc = 'Delete trailing whitespace',
  },
  {
    '<leader>cW',
    function()
      require('mini.trailspace').trim_last_lines()
    end,
    desc = 'Delete trailing newlines',
  },
  ]]
  },
  config = function()
    require('mini.trailspace').setup()
  end,
}
