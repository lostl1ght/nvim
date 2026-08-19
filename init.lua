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

---@param path string
---@return string
_G.gh = function(path) return 'https://github.com/' .. path end

vim.pack.add({ gh('nvim-mini/mini.misc') })
require('mini.misc').setup({ make_global = {} })
_G.put = MiniMisc.put
_G.safely = MiniMisc.safely
