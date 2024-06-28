---@type LazyPluginSpec
return {
  'kawre/neotab.nvim',
  config = function()
    require('neotab').setup({ tabkey = '' })
  end,
}
