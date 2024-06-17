local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
  vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazy_path,
    })
    :wait()
end

vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup('plugins', {
  defaults = {
    lazy = true,
  },
  lockfile = vim.fn.stdpath('state') .. '/lazy-lock.json',
  dev = {
    path = vim.fs.normalize('~/dev/plugins'),
  },
  ui = {
    border = 'single',
  },
  checker = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

vim.keymap.set('n', '<leader>pl', '<cmd>Lazy<cr>', { desc = 'Lazy' })
