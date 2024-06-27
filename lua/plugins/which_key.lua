---@type LazyPluginSpec
return {
  'folke/which-key.nvim',
  enabled = false,
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup({
      show_help = false,
      show_keys = false,
      triggers_blacklist = {
        i = { 'j', 'k', 'i' },
        v = { 'j', 'k', 'i' },
      },
      window = {
        border = 'none',
      },
    })
    wk.register({
      ['<leader>'] = {
        b = { name = 'buffer' },
        c = { name = 'code' },
        f = { name = 'file' },
        h = { name = 'trident' },
        p = { name = 'package' },
        q = { name = 'quit/session' },
        t = { name = 'toggle' },
      },
    }, {})
  end,
}
