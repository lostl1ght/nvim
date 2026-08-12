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

vim.g.border = 'single'
vim.g.notify_toggle = true

vim.pack.add({ 'https://github.com/nvim-mini/mini.misc' })
require('mini.misc').setup({ make_global = { 'put', 'safely' } })
