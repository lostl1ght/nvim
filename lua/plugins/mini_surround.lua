---@type LazyPluginSpec
return {
  'echasnovski/mini.surround',
  event = 'VeryLazy',
  config = function()
    require('mini.surround').setup({
      mappings = {
        add = 'ma',
        delete = 'md',
        find = 'mf',
        find_left = 'mF',
        highlight = 'mh',
        replace = 'mr',
        update_n_lines = 'mn',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    })
    vim.keymap.set('n', 'gm', 'm', { desc = 'Marks' })
    local okc, mc = pcall(require, 'mini.clue')
    if okc then
      table.insert(mc.config.triggers, { mode = 'n', keys = 'm' })
    end
  end,
}
