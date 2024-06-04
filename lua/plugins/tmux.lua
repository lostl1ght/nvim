return {
  'aserowy/tmux.nvim',
  keys = {
    {
      '<c-l>',
      function()
        require('tmux').move_right()
      end,
      desc = 'Right window',
    },
    {
      '<c-k>',
      function()
        require('tmux').move_top()
      end,
      desc = 'Upper window',
    },
    {
      '<c-j>',
      function()
        require('tmux').move_bottom()
      end,
      desc = 'Lower window',
    },
    {
      '<c-h>',
      function()
        require('tmux').move_left()
      end,
      desc = 'Left window',
    },
    {
      '<c-m-l>',
      function()
        require('tmux').resize_right()
      end,
      desc = 'Resize right window',
    },
    {
      '<c-m-k>',
      function()
        require('tmux').resize_top()
      end,
      desc = 'Resize upper window',
    },
    {
      '<c-m-j>',
      function()
        require('tmux').resize_bottom()
      end,
      desc = 'Resize lower window',
    },
    {
      '<c-m-h>',
      function()
        require('tmux').resize_left()
      end,
      desc = 'Resize left window',
    },
  },
  config = function()
    require('tmux').setup({
      copy_sync = {
        enable = false,
      },
      navigation = {
        enable_default_keybindings = false,
      },
      resize = {
        enable_default_keybindings = false,
        resize_step_x = 3,
        resize_step_y = 3,
      },
    })
  end,
}
