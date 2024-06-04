return {
  'boltlessengineer/smart-tab.nvim',
  event = 'VeryLazy',
  config = function()
    require('smart-tab').setup({
      skips = { 'string_content' },
      mapping = '<tab>',
    })
  end,
}
