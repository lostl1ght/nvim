local root = '/tmp/nvim'

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local lazy_path = root .. '/plugins/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
  vim.api.nvim_cmd({
    cmd = '!',
    args = {
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazy_path,
    },
  }, {})
end
vim.opt.runtimepath:prepend(lazy_path)

local plugins = {
  { 'folke/lazy.nvim' },
  { 'rebelot/kanagawa.nvim' },
  -- plugins
}

vim.g.mapleader = ' '

require('lazy').setup(plugins, {
  root = root .. '/plugins',
})

vim.opt.termguicolors = true
vim.cmd('colorscheme kanagawa')
