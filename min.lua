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
  vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/echasnovski/mini.deps',
      deps_path,
    })
    :wait()
  vim.cmd('helptags ALL')
  vim.api.nvim_echo({ { 'Installed `mini.deps`', 'MoreMsg' } }, true, {})
end

vim.opt.runtimepath:prepend(deps_path)

local ok, MiniDeps = pcall(require, 'mini.deps')

if not ok then
  vim.api.nvim_echo({
    { ('Unable to load `mini.deps` from: %s\n'):format(deps_path), 'ErrorMsg' },
    { 'Press any key to exit...', 'MoreMsg' },
  }, true, {})
  vim.fn.getchar()
  vim.cmd('quit')
end

MiniDeps.setup({ path = { package = path_package } })

local add, now = MiniDeps.add, MiniDeps.now

now(function()
  add({ source = 'rebelot/kanagawa.nvim' })
  require('kanagawa').setup()
  vim.opt.termguicolors = true
  vim.cmd('colorscheme kanagawa')
end)
