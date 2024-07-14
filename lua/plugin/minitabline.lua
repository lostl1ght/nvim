local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'echasnovski/mini.tabline', depends = { 'echasnovski/mini.icons' } })
  vim.api.nvim_create_autocmd('User', {
    pattern = { 'GitSignsUpdate', 'GitSignsChanged' },
    callback = vim.schedule_wrap(function() vim.cmd('redrawtabline') end),
    group = vim.api.nvim_create_augroup('StatuslineGit', {}),
  })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = vim.schedule_wrap(function() vim.cmd('redrawtabline') end),
    group = vim.api.nvim_create_augroup('StatuslineDiagnostics', {}),
  })
  local minitabline = require('mini.tabline')
  minitabline.setup({
    format = function(buf_id, label)
      local git = ''
      local gsd = vim.b[buf_id].gitsigns_status_dict
      if gsd then
        if gsd.added and gsd.added > 0 then git = git .. '+' end
        if gsd.changed and gsd.changed > 0 then git = git .. '~' end
        if gsd.removed and gsd.removed > 0 then git = git .. '-' end
      end
      local has = function(severity) return #vim.diagnostic.get(buf_id, { severity = severity }) > 0 end

      local diagnostics = ''
      local severity = vim.diagnostic.severity
      if has(severity.ERROR) then diagnostics = diagnostics .. 'E' end
      if has(severity.WARN) then diagnostics = diagnostics .. 'W' end
      if has(severity.INFO) then diagnostics = diagnostics .. 'I' end
      if has(severity.HINT) then diagnostics = diagnostics .. 'H' end

      local suffix = ''
      if git ~= '' then suffix = suffix .. git .. ' ' end
      if diagnostics ~= '' then suffix = suffix .. diagnostics .. ' ' end

      return minitabline.default_format(buf_id, label) .. suffix
    end,
  })
end)
