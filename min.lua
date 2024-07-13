local root = '/tmp/nvim'

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local path_package = vim.fn.stdpath('data') .. '/site/'
local deps_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.uv.fs_stat(deps_path) then
  if vim.fn.executable('git') == 0 then
    vim.api.nvim_echo({
      { 'git is not installed\n', 'ErrorMsg' },
      { 'Press any key to exit...', 'MoreMsg' },
    }, true, {})
    vim.fn.getchar()
    vim.cmd('quit')
  end
  vim.api.nvim_echo({ { 'Installing `mini.deps`', 'WarningMsg' } }, true, {})
  -- stylua: ignore
  vim.system({
    'git',   'clone',   '--filter=blob:none',  '--single-branch',
    'https://github.com/echasnovski/mini.deps', deps_path,
  }):wait()
  vim.cmd('packadd mini.deps')
  vim.cmd('helptags ALL')
  vim.api.nvim_echo({ { 'Installed `mini.deps`', 'MoreMsg' } }, true, {})
end

local ok, minideps = pcall(require, 'mini.deps')

if not ok then
  vim.api.nvim_echo({
    { ('Unable to load `mini.deps` from: %s\n'):format(deps_path), 'ErrorMsg' },
    { 'Press any key to exit...', 'MoreMsg' },
  }, true, {})
  vim.fn.getchar()
  vim.cmd('quit')
end

minideps.setup({ path = { package = path_package } })

local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'rebelot/kanagawa.nvim' })
  require('kanagawa').setup()
  vim.opt.termguicolors = true
  vim.cmd('colorscheme kanagawa')
end)
