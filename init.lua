vim.loader.enable()

-- stylua: ignore
local rtp = {
  'gzip',          'tar',           'tarPlugin',         'zip',
  'zipPlugin',     'getscript',     'getscriptPlugin',   'vimball',
  'vimballPlugin', 'matchit',       'matchparen',        'spellfile_plugin',
  '2html_plugin',  'logiPat',       'rrhelper',          'netrw',
  'netrwPlugin',   'netrwSettings', 'netrwFileHandlers', 'tutor_mode_plugin',
}
for _, p in ipairs(rtp) do
  vim.g['loaded_' .. p] = 1
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
vim.g.border = 'single'
vim.g.notify_toggle = not vim.g.vscode

local now = minideps.now
for f in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/config') do
  now(function() require('config.' .. vim.fn.fnamemodify(f, ':r')) end)
end

for f in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/plugin/universal') do
  require('plugin.universal.' .. vim.fn.fnamemodify(f, ':r'))
end

if not vim.g.vscode then
  for f in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/plugin/nocode') do
    require('plugin.nocode.' .. vim.fn.fnamemodify(f, ':r'))
  end
end
