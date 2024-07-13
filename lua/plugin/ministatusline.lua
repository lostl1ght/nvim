local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'echasnovski/mini.statusline', depends = { 'echasnovski/mini.icons' } })
  local miniicons = require('mini.icons')
  local use_icons = miniicons.config.style == 'glyph'
  local icons = {
    [1] = {
      lsp = { ascii = 'LSP', glyph = '' },
    },
  }
  setmetatable(icons, {
    __index = function(t, k) return t[1][k][miniicons.config.style] end,
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
    local ministatusline = require('mini.statusline')
    local ro = vim.bo.readonly
    local mod = vim.bo.modified
    local suffix = ro and '[ro]' or mod and '[+]' or ''
    if vim.bo.buftype == 'terminal' then
      return '%t'
    elseif ministatusline.is_truncated(args.trunc_width) then
      return '%t ' .. suffix
    else
      return '%f ' .. suffix
    end
  end
  require('mini.statusline').setup({
    use_icons = use_icons,
    content = {
      active = function()
        local ministatusline = require('mini.statusline')
        local mode, mode_hl = ministatusline.section_mode({ trunc_width = 120 })
        local git = ministatusline.section_git({ trunc_width = 40 })
        local diff = ministatusline.section_diff({ trunc_width = 75 })
        local diagnostics = ministatusline.section_diagnostics({ trunc_width = 75 })
        local lsp = ministatusline.section_lsp({ icon = icons.lsp, trunc_width = 75 })
        local filename = section_filename({ trunc_width = 100 })
        local fileinfo = ministatusline.section_fileinfo({ trunc_width = 120 })
        local location = ministatusline.section_location({ trunc_width = 75 })
        local search = ministatusline.section_searchcount({ trunc_width = 75 })
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
        local ministatusline = require('mini.statusline')
        local diff = ministatusline.section_diff({ trunc_width = 75 })
        local diagnostics = ministatusline.section_diagnostics({ trunc_width = 75 })
        local filename = section_filename({ trunc_width = 100 })

        return ministatusline.combine_groups({
          { hl = 'MiniStatuslineInactive', strings = { diff, diagnostics } },
          '%<',
          { hl = 'MiniStatuslineInactive', strings = { filename } },
        })
      end,
    },
  })
end)
