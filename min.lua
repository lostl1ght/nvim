local root = '/tmp/nvim'

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local path_package = vim.fn.stdpath('data') .. '/site/'
local deps_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.uv.fs_stat(deps_path) then
  -- stylua: ignore
  vim.system({
    'git',   'clone',   '--filter=blob:none',  '--single-branch',
    'https://github.com/echasnovski/mini.deps', deps_path,
  }):wait()
  vim.cmd('packadd mini.deps')
  vim.cmd('helptags ALL')
end

local minideps = require('mini.deps')

minideps.setup({ path = { package = path_package } })

local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'rebelot/kanagawa.nvim' })
  require('kanagawa').setup()
  vim.o.termguicolors = true
  vim.cmd('colorscheme kanagawa')
end)
