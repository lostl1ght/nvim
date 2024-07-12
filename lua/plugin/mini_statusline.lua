local MiniDeps = require('mini.deps')
local add, now = MiniDeps.add, MiniDeps.now

now(function()
  add({ source = 'echasnovski/mini.statusline', depends = { 'echasnovski/mini.icons' } })
  local use_icons = MiniIcons.config.style == 'glyph'
  local icons = {
    [1] = {
      x = { ascii = 'X', glyph = '' },
      lsp = { ascii = 'LSP', glyph = '' },
    },
  }
  setmetatable(icons, {
    __index = function(t, k) return t[1][k][MiniIcons.config.style] end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = { 'GitSignsUpdate', 'GitSignsChanged' },
    callback = vim.schedule_wrap(function() vim.cmd('redrawstatus') end),
    group = vim.api.nvim_create_augroup('StatuslineGit', {}),
  })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = vim.schedule_wrap(function() vim.cmd('redrawstatus') end),
    group = vim.api.nvim_create_augroup('StatuslineDiagnostics', {}),
  })
  local section_filename = function(args)
    local ro = vim.bo.readonly
    local mod = vim.bo.modified
    local suffix = ro and '[ro]' or mod and '[+]' or ''
    if vim.bo.buftype == 'terminal' then
      return '%t'
    elseif MiniStatusline.is_truncated(args.trunc_width) then
      return '%t ' .. suffix
    else
      return '%f ' .. suffix
    end
  end
  require('mini.statusline').setup({
    use_icons = use_icons,
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local lsp = MiniStatusline.section_lsp({ icon = icons.lsp, trunc_width = 75 })
        local filename = section_filename({ trunc_width = 100 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
        local macro = (function()
          if vim.fn.reg_recording() == '' then return '' end
          return '[' .. vim.fn.reg_recording() .. ']'
        end)()

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
          '%<',
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=',
          { hl = 'MiniStatuslineFilename', strings = { macro } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,

      inactive = function()
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local filename = section_filename({ trunc_width = 100 })

        return MiniStatusline.combine_groups({
          { hl = 'MiniStatuslineInactive', strings = { diff, diagnostics } },
          '%<',
          { hl = 'MiniStatuslineInactive', strings = { filename } },
        })
      end,
    },
  })
  --[[
vim.go.tabline = '%!v:lua.MiniTabline()'
_G.MiniTabline = function()
  local close = function(tabnr, icon) return table.concat({ '%', tabnr, 'X', icon, '%X' }) end
  local win_count = function(n) return n > 1 and tostring(n) or '' end
  local get = function(bufnr)
    local category, name
    if vim.bo[bufnr].filetype ~= '' then
      category, name = 'filetype', vim.bo[bufnr].filetype
    else
      category, name = 'file', vim.fn.bufname(bufnr)
    end
    return MiniIcons.get(category, name)
  end
  local tab_page = function(tabnr, strings)
    local string_arr = vim.tbl_filter(
      function(x) return type(x) == 'string' and x ~= '' end,
      strings or {}
    )
    local str = table.concat(string_arr, ' ')
    return table.concat({ '%', tabnr, 'T', str, '%T' })
  end
  local tabline = ''
  local tabpages = vim.api.nvim_list_tabpages()
  for _, tabpage in ipairs(tabpages) do
    local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
    local buflist = vim.fn.tabpagebuflist(tabnr)
    local w = 0
    local modified = ''
    for _, v in ipairs(buflist) do
      if vim.bo[v].buflisted then
        w = w + 1
        if vim.bo[v].modified then modified = '[+]' end
      end
    end
    local winnr = vim.fn.tabpagewinnr(tabnr)
    local bufnr = buflist[winnr]
    local icon = get(bufnr)
    local bufname = vim.fn.bufname(bufnr)
    local filename
    if bufname == '' then
      filename = '[No Name]'
    elseif vim.bo[bufnr].filetype == 'help' or vim.bo[bufnr].buftype == 'terminal' then
      filename = vim.fn.fnamemodify(bufname, ':t')
    else
      filename = vim.fn.pathshorten(vim.fn.fnamemodify(bufname, ':~:.'), 2)
    end
    local hl = tabpage == vim.api.nvim_get_current_tabpage() and 'MiniStatuslineDevinfo'
      or 'MiniStatuslineFilename'
    tabline = MiniStatusline.combine_groups({
      tabline,
      {
        hl = hl,
        strings = {
          tab_page(tabnr, {
            icon,
            win_count(w),
            filename,
            modified,
            close(tabnr, icons.x),
          }),
        },
      },
    })
  end
  return MiniStatusline.combine_groups({
    tabline,
    { hl = 'TabLineFill', strings = { '%T' } },
  })
end
]]
end)
