---@type LazyPluginSpec
return {
  'folke/persistence.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Load current directory',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Load last session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
        vim.notify('stopped', vim.log.levels.INFO, { title = 'Persistence' })
      end,
      desc = 'Stop recording session',
    },
    {
      '<leader>qD',
      function()
        require('persistence').start()
        vim.notify('started', vim.log.levels.INFO, { title = 'Persistence' })
      end,
      desc = 'Start recording session',
    },
  },

  config = function()
    require('persistence').setup()
  end,
}
