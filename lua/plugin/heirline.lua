local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'rebelot/heirline.nvim' })
  vim.api.nvim_create_autocmd('User', {
    pattern = { 'GitSignsUpdate', 'GitSignsChanged' },
    callback = vim.schedule_wrap(function() vim.cmd('redrawstatus') end),
    group = vim.api.nvim_create_augroup('StatuslineGit', {}),
  })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = vim.schedule_wrap(function() vim.cmd('redrawstatus') end),
    group = vim.api.nvim_create_augroup('StatuslineDiagnostics', {}),
  })

  local is_active = function()
    local winid = vim.api.nvim_get_current_win()
    local curwin = tonumber(vim.g.actual_curwin)
    return winid == curwin
  end

  local icons = {
    [1] = {
      lsp = { ascii = 'LSP', glyph = '' },
      ro = { ascii = '[ro]', glyph = '' },
      mod = { ascii = '[+]', glyph = '' },
      x = { ascii = 'X', glyph = '' },
      diff = { ascii = 'Diff', glyph = '' },
      diag = { ascii = 'Diag', glyph = '' },
    },
  }
  setmetatable(icons, {
    __index = function(t, k) return t[1][k][require('mini.icons').config.style] end,
  })

  local Space = { provider = ' ' }
  local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
  local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
  local priority = {
    mode = 25,
    location = 20,
    diff = 15,
    diag = 15,
    path = 10,
    lsp = 5,
    fileinfo = 5,
  }

  local Mode = {
    condition = is_active,
    flexible = priority.mode,
    {
      provider = function(self) return ' ' .. self.modes[vim.fn.mode()].long .. ' ' end,
      hl = function(self) return self.modes[vim.fn.mode()].hl end,
    },
    {
      provider = function(self) return ' ' .. self.modes[vim.fn.mode()].short .. ' ' end,
      hl = function(self) return self.modes[vim.fn.mode()].hl end,
    },
  }

  local Location = {
    condition = is_active,
    flexible = priority.location,
    { provider = ' %l|%L│%2v|%-2{virtcol("$") - 1} ' },
    { provider = ' %l│%2v ' },
    hl = function(self) return self.modes[vim.fn.mode()].hl end,
  }

  local Diff = {
    flexible = priority.diff,
    {
      condition = function(self)
        local status = vim.b.gitsigns_status_dict
        if not status then return false end
        self.added, self.changed, self.removed = status.added, status.changed, status.removed
        return true
      end,
      {
        provider = function() return ' ' .. icons.diff end,
        {
          condition = function(self)
            return not (self.added and self.changed and self.removed)
              or (self.added == 0 and self.changed == 0 and self.removed == 0)
          end,
          provider = ' -',
        },
        hl = function()
          if is_active() then
            return 'MiniStatuslineDevinfo'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
      {
        condition = function(self) return self.removed and self.removed > 0 end,
        hl = function()
          if is_active() then
            return '@diff.minus'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return '-' .. self.removed end },
      },
      {
        condition = function(self) return self.changed and self.changed > 0 end,
        hl = function()
          if is_active() then
            return '@diff.delta'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return '~' .. self.changed end },
      },
      {
        condition = function(self) return self.added and self.added > 0 end,
        hl = function()
          if is_active() then
            return '@diff.plus'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return '+' .. self.added end },
      },
    },
  }
  local diagnostic_is_enabled = function() return vim.diagnostic.is_enabled({ bufnr = 0 }) end
  local diagnostic_get_count = function() return vim.diagnostic.count(0) end

  local Diagnostic = {
    flexible = priority.diag,
    {
      static = {
        sings = {
          ERROR = 'E',
          WARN = 'W',
          INFO = 'I',
          HINT = 'H',
        },
        severity = vim.diagnostic.severity,
      },
      condition = function() return diagnostic_is_enabled() and #diagnostic_get_count() > 0 end,
      {
        provider = function() return ' ' .. icons.diag end,
        hl = function()
          if is_active() then
            return 'MiniStatuslineDevinfo'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
      {
        condition = function(self)
          self.errors = diagnostic_get_count()[self.severity['ERROR']]
          return self.errors and self.errors > 0
        end,
        hl = function()
          if is_active() then
            return 'DiagnosticError'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return self.sings.ERROR .. tostring(self.errors) end },
      },
      {
        condition = function(self)
          self.warn = diagnostic_get_count()[self.severity['WARN']]
          return self.warn and self.warn > 0
        end,
        hl = function()
          if is_active() then
            return 'DiagnosticWarn'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return self.sings.WARN .. tostring(self.warn) end },
      },
      {
        condition = function(self)
          self.info = diagnostic_get_count()[self.severity['INFO']]
          return self.info and self.info > 0
        end,
        hl = function()
          if is_active() then
            return 'DiagnosticInfo'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return self.sings.INFO .. tostring(self.info) end },
      },
      {
        condition = function(self)
          self.hint = diagnostic_get_count()[self.severity['HINT']]
          return self.hint and self.hint > 0
        end,
        hl = function()
          if is_active() then
            return 'DiagnosticHint'
          else
            return 'MiniStatuslineInactive'
          end
        end,
        Space,
        { provider = function(self) return self.sings.HINT .. tostring(self.hint) end },
      },
    },
    { provider = '' },
  }

  local Search = {
    condition = function() return is_active() and vim.v.hlsearch == 1 end,
    hl = function(self) return self.modes[vim.fn.mode()].hl end,
    provider = function()
      local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
      if not ok or s_count.current == nil or s_count.total == 0 then return '' end

      if s_count.incomplete == 1 then return ' ?/?' end

      local too_many = '>' .. s_count.maxcount
      local current = s_count.current > s_count.maxcount and too_many or s_count.current
      local total = s_count.total > s_count.maxcount and too_many or s_count.total
      return ' ' .. current .. '/' .. total
    end,
  }

  local attached_lsp = {}
  local get_buf_lsp_clients = function(buf_id) return vim.lsp.get_clients({ bufnr = buf_id }) end
  local compute_attached_lsp = function(buf_id)
    return string.rep('+', vim.tbl_count(get_buf_lsp_clients(buf_id)))
  end
  local get_attached_lsp = function() return attached_lsp[vim.api.nvim_get_current_buf()] or '' end
  vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    callback = vim.schedule_wrap(function(data)
      attached_lsp[data.buf] = compute_attached_lsp(data.buf)
      vim.cmd('redrawstatus')
    end),
  })

  local Lsp = {
    flexible = priority.lsp,
    {
      condition = function() return is_active() and get_attached_lsp() ~= '' end,
      Space,
      {
        provider = function()
          local attached = get_attached_lsp()
          return icons.lsp .. ' ' .. attached
        end,
      },
    },
    { provider = '' },
  }

  local FileInfo = {
    flexible = priority.fileinfo,
    {
      static = {
        get_filesize = function()
          local size = vim.fn.getfsize(vim.fn.getreg('%'))
          if size < 1024 then
            return string.format('%dB', size)
          elseif size < 1048576 then
            return string.format('%.2fKiB', size / 1024)
          else
            return string.format('%.2fMiB', size / 1048576)
          end
        end,
      },
      condition = function() return is_active() and vim.bo.filetype ~= '' end,
      provider = function(self)
        local filetype = vim.bo.filetype
        local icon = require('mini.icons').get('filetype', filetype)
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        local format = vim.bo.fileformat
        local size = self.get_filesize()

        return (' %s %s %s[%s] %s '):format(icon, filetype, encoding, format, size)
      end,
      hl = 'MiniStatuslineDevinfo',
    },
    { provider = '' },
  }

  local Filename = {
    static = {
      sep = package.config:sub(1, 1),
    },
    init = function(self)
      local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
      local file = vim.fn.expand('%:t')

      if path == '.' or file == '' then
        path = ''
      else
        path = path .. self.sep
      end
      if file == '' then file = '[No Name]' end
      self.path = path
      self.file = file

      self.suffix = vim.bo.readonly and icons.ro or vim.bo.modified and icons.mod or ''
    end,
    condition = function(self) return self.path ~= '' or self.file ~= '' or self.suffix ~= '' end,
    {
      {
        Space,
        hl = function()
          if is_active() then
            return 'MiniStatuslinePath'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
      {
        flexible = priority.path,
        { provider = function(self) return self.path end },
        { provider = function(self) return vim.fn.pathshorten(self.path, 2) end },
        { provider = '' },
        hl = function()
          if is_active() then
            return 'MiniStatuslinePath'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
      {
        provider = function(self) return self.file end,
        hl = function()
          if is_active() then
            return 'MiniStatuslineFilename'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
      {
        condition = function(self) return self.suffix ~= '' end,
        provider = function(self) return ' ' .. self.suffix end,
        hl = function()
          if is_active() then
            return 'DiagnosticError'
          else
            return 'MiniStatuslineInactive'
          end
        end,
      },
    },
  }

  local Statusline = {
    static = {
      modes = setmetatable({
        ['n'] = { long = 'Normal', short = 'N', hl = 'MiniStatuslineModeNormal' },
        ['v'] = { long = 'Visual', short = 'V', hl = 'MiniStatuslineModeVisual' },
        ['V'] = { long = 'V-Line', short = 'V-L', hl = 'MiniStatuslineModeVisual' },
        [CTRL_V] = { long = 'V-Block', short = 'V-B', hl = 'MiniStatuslineModeVisual' },
        ['s'] = { long = 'Select', short = 'S', hl = 'MiniStatuslineModeVisual' },
        ['S'] = { long = 'S-Line', short = 'S-L', hl = 'MiniStatuslineModeVisual' },
        [CTRL_S] = { long = 'S-Block', short = 'S-B', hl = 'MiniStatuslineModeVisual' },
        ['i'] = { long = 'Insert', short = 'I', hl = 'MiniStatuslineModeInsert' },
        ['R'] = { long = 'Replace', short = 'R', hl = 'MiniStatuslineModeReplace' },
        ['c'] = { long = 'Command', short = 'C', hl = 'MiniStatuslineModeCommand' },
        ['r'] = { long = 'Prompt', short = 'P', hl = 'MiniStatuslineModeOther' },
        ['!'] = { long = 'Shell', short = 'Sh', hl = 'MiniStatuslineModeOther' },
        ['t'] = { long = 'Terminal', short = 'T', hl = 'MiniStatuslineModeOther' },
      }, {
        __index = function()
          return { long = 'Unknown', short = 'U', hl = 'MiniStatuslineModeOther' }
        end,
      }),
    },
    Mode,
    {
      hl = 'MiniStatuslineDevinfo',
      Diff,
      Diagnostic,
      Lsp,
      {
        condition = function()
          return get_attached_lsp() ~= ''
            or diagnostic_is_enabled() and #diagnostic_get_count() > 0
            or vim.b.gitsigns_status_dict
        end,
        Space,
        hl = function()
          if not is_active() then return 'MiniStatuslineInactive' end
        end,
      },
    },
    { provider = '%<' },
    {
      hl = 'StatusLine',
      Filename,
    },
    { provider = '%=' },
    FileInfo,
    Search,
    Location,
  }

  local Tabline = {
    {
      provider = function()
        local n_tabpages = vim.fn.tabpagenr('$')
        local cur_tabpagenr = vim.fn.tabpagenr()
        local tabpage_section = (' Tab %s/%s '):format(cur_tabpagenr, n_tabpages)
        return tabpage_section
      end,
      hl = 'MiniTablineTabpagesection',
    },
    { provider = '%=', hl = 'TabLineFill' },
    { provider = function() return '%999X' .. icons.x end, hl = 'TabLineFill' },
  }

  require('heirline').setup({
    statusline = Statusline,
    tabline = Tabline,
  })
end)
