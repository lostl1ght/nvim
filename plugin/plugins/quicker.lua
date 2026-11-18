safely('later', function()
  packadd({ 'stevearc/quicker.nvim' })

  local set = vim.keymap.set
  set('n', 'grq', function() require('quicker').toggle() end, { desc = 'Quickfix' })
  set(
    'n',
    'grl',
    function() require('quicker').toggle({ loclist = true }) end,
    { desc = 'Loclist' }
  )
  require('quicker').setup({
    keys = {
      {
        '>',
        function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function() require('quicker').collapse() end,
        desc = 'Collapse quickfix context',
      },
    },
  })
end)
