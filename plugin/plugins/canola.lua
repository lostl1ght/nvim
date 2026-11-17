safely('now', function()
  vim.g.canola = {
    delete = { wipe = true, recursive = true },
    columns = { 'git_status', 'icon' },
    watch = true,
    keymaps = {
      ['='] = 'actions.select',
    },
  }
  vim.g.canola_git = {}

  vim.pack.add({
    { src = gh('barrettruth/canola.nvim'), version = 'canola' },
    gh('barrettruth/canola-collection'),
  }, { confirm = false })
end)
