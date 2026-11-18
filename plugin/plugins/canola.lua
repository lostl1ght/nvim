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

  packadd({
    { src = 'barrettruth/canola.nvim', version = 'canola' },
    'barrettruth/canola-collection',
  })
end)
