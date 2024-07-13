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
      local gs = vim.b[buf_id].gitsigns_status_dict
      if gs then
        if gs.added and gs.added > 0 then git = git .. '+' end
        if gs.changed and gs.changed > 0 then git = git .. '~' end
        if gs.removed and gs.removed > 0 then git = git .. '-' end
      end
      local get = function(severity) return #vim.diagnostic.get(buf_id, { severity = severity }) end

      local diagnostics = ''
      if get(vim.diagnostic.severity.ERROR) > 0 then diagnostics = diagnostics .. 'E' end
      if get(vim.diagnostic.severity.WARN) > 0 then diagnostics = diagnostics .. 'W' end
      if get(vim.diagnostic.severity.INFO) > 0 then diagnostics = diagnostics .. 'I' end
      if get(vim.diagnostic.severity.HINT) > 0 then diagnostics = diagnostics .. 'H' end

      local suffix = ''
      if git ~= '' then suffix = suffix .. git .. ' ' end
      if diagnostics ~= '' then suffix = suffix .. diagnostics .. ' ' end

      return minitabline.default_format(buf_id, label) .. suffix
    end,
  })
end)
