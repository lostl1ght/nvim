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
  vim.notify('Installing `mini.deps`', vim.log.levels.WARN)
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
  vim.notify('Installend `mini.deps`', vim.log.levels.INFO)
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

require('plugin.mini_icons')
require('plugin.kanagawa')
require('plugin.mini_statusline')
require('plugin.treesitter')
require('plugin.noice')

require('plugin.luasnip') -- before cmp
require('plugin.autopairs') -- before cmp
require('plugin.cmp')
require('plugin.conform')
require('plugin.dressing')
require('plugin.flash')
require('plugin.mini_clue') -- before gitsigns
require('plugin.gitsigns')
require('plugin.indent_blankline')
require('plugin.lazygit')
