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
local misc = require('mini.misc')
misc.setup({ make_global = { 'put', 'safely' } })
_G.put, _G.safely = misc.put, misc.safely

---@param path string
---@return string
_G.gh = function(path)
  if path:match('^%a[%w+.-]*://') or path:match('^git@') or path:match('^[~/.]') then
    return path
  end
  return 'https://github.com/' .. path
end

---@param specs (string|vim.pack.Spec)[]
---@param opts? vim.pack.keyset.add
_G.packadd = function(specs, opts)
  local resolved = {}
  for _, v in ipairs(specs) do
    if type(v) == 'string' then
      table.insert(resolved, { src = gh(v) })
    elseif type(v) == 'table' and v.src then
      table.insert(resolved, vim.tbl_extend('force', v, { src = gh(v.src) }))
    else
      vim.notify('packadd: invalid spec ' .. vim.inspect(v), vim.log.levels.WARN)
    end
  end
  vim.pack.add(resolved, vim.tbl_extend('force', { confirm = false }, opts or {}))
end
