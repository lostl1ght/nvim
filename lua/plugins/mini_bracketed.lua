---@type LazyPluginSpec
return {
  'echasnovski/mini.bracketed',
  event = 'VeryLazy',
  config = function()
    require('mini.bracketed').setup({
      comment = { suffix = '' },
      file = { suffix = '' },
      treesitter = { suffix = '' },
      indent = { suffix = '' },
      oldfile = { suffix = '' },
    })
  end,
}
