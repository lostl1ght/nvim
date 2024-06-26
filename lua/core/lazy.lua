local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
  if vim.fn.executable('git') == 0 then
    vim.api.nvim_echo({
      { 'git is not installed\n', 'ErrorMsg' },
      { 'Press any key to exit...', 'MoreMsg' },
    }, true, {})
    vim.fn.getchar()
    vim.cmd('quit')
  end
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

local ok, lazy = pcall(require, 'lazy')

if not ok then
  vim.api.nvim_echo({
    { ('Unable to load lazy from: %s\n'):format(lazy_path), 'ErrorMsg' },
    { 'Press any key to exit...', 'MoreMsg' },
  }, true, {})
  vim.fn.getchar()
  vim.cmd('quit')
end

lazy.setup('plugins', {
  defaults = {
    lazy = true,
  },
  pkg = { sources = { 'lazy' } },
  lockfile = vim.fn.stdpath('state') .. '/lazy-lock.json',
  dev = { path = vim.fs.normalize('~/dev/plugins') },
  ui = { border = 'single', backdrop = 100 },
  checker = { enabled = false, notify = false },
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
  -- profiling = { loader = true, require = true },
})

vim.keymap.set('n', '<leader>pl', '<cmd>Lazy<cr>', { desc = 'Lazy' })
