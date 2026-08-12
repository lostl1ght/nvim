safely(
  'later',
  function()
    require('neotab').setup({
      pairs = {
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '<', close = '>' },
        { open = '$', close = '$' },
      },
    })
  end
)

safely('later', function()
  require('keymap_switch').setup({ keymap = 'russian-jcukenwin' })
  vim.keymap.set(
    { 'c', 'i', 'n', 's', 'x' },
    '<c-\\>',
    '<plug>(keymap-switch)',
    { desc = 'Switch layout' }
  )
end)
