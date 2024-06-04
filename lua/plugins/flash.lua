return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  keys = {
    {
      's',
      function()
        require('flash').jump()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Flash jump',
    },
    {
      'S',
      function()
        require('flash').treesitter()
      end,
      mode = { 'n', 'o', 'x' },
      desc = 'Flash treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote flash',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Flash treesitter Search',
    },
    {
      '<c-s>',
      mode = 'c',
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle flash Search',
    },
  },
  config = function()
    require('flash').setup({
      search = {
        exclude = {
          'notify',
          'cmp_menu',
          'cmp_docs',
          'noice',
          'flash_prompt',
          function(win)
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },
      modes = {
        search = {
          enabled = false,
          --[[
        search = {
          trigger = '`',
          incremental = true,
        },
        --]]
        },
        char = {
          jump_labels = true,
        },
        treesitter = {
          label = {
            rainbow = { enabled = true, shade = 4 },
          },
        },
        treesitter_search = {
          label = {
            rainbow = { enabled = true, shade = 4 },
          },
        },
      },
      prompt = {
        prefix = { { '  󱐋 ', 'FlashPromptIcon' } },
      },
    })
  end,
}
