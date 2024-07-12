vim.loader.enable()

vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_tutor_mode_plugin = 1

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
  vim.cmd('packadd mini.deps')
  vim.cmd('helptags ALL')
  vim.api.nvim_echo({ { 'Installed `mini.deps`', 'MoreMsg' } }, true, {})
end

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
vim.g.border = 'single'

local now = MiniDeps.now
for f in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/config') do
  now(function() require('config.' .. vim.fn.fnamemodify(f, ':r')) end)
end

for f in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/plugin') do
  require('plugin.' .. vim.fn.fnamemodify(f, ':r'))
end
