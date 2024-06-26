---@type LazyPluginSpec
return {
  'stevearc/dressing.nvim',

  event = 'VeryLazy',

  config = function()
    require('dressing').setup({
      input = {
        relative = 'editor',
        border = 'single',
      },
      select = {
        nui = {
          border = {
            style = 'single',
          },
        },
        builtin = {
          border = 'single',
        },
      },
    })
  end,
}
