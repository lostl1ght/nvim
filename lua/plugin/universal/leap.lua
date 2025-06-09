local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'ggandor/leap.nvim' })
  vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
  vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
  require('leap').opts.preview_filter = function(ch0, ch1, ch2)
    return not (ch1:match('%s') or ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  end
  require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
  require('leap.user').set_repeat_keys('<enter>', '<backspace>')
  vim.keymap.set({ 'x', 'o' }, 'R', function() require('leap.treesitter').select() end)
end)

later(function()
  add({ source = 'ggandor/flit.nvim' })
  require('flit').setup({ labeled_modes = 'nvo' })
end)

later(function() add({ source = 'tpope/vim-repeat' }) end)
