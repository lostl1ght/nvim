local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'rebelot/heirline.nvim', depends = { 'echasnovski/mini.icons' } })

  local is_active = function()
    local winid = vim.api.nvim_get_current_win()
    local curwin = tonumber(vim.g.actual_curwin)
    return winid == curwin
  end

  local icons = setmetatable({
    [1] = {
      lsp = { ascii = 'LSP', glyph = '' },
      ro = { ascii = '[ro]', glyph = '' },
      mod = { ascii = '[+]', glyph = '' },
      x = { ascii = 'X', glyph = '' },
      diff = { ascii = 'Diff', glyph = '' },
      diag = { ascii = 'Diag', glyph = '' },
      error = { ascii = 'E', glyph = 'E' },
      warn = { ascii = 'W', glyph = 'W' },
      info = { ascii = 'I', glyph = 'I' },
      hint = { ascii = 'H', glyph = 'H' },
      minus = { ascii = '-', glyph = '-' },
      delta = { ascii = '~', glyph = '~' },
      plus = { ascii = '+', glyph = '+' },
      branch = { ascii = 'Git', glyph = '' },
      tabprevious = { ascii = '<', glyph = '' },
      tabnext = { ascii = '>', glyph = '' },
    },
  }, {
    __index = function(self, key) return self[1][key][require('mini.icons').config.style] end,
  })

  local Space = { provider = ' ' }

  local priority = {
    diff = 60,
    diag = 60,
    branch = 50,
    path = 40,
    fileinfo = 30,
    location = 20,
    mode = 20,
    lsp = 10,
  }

  local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
  local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
  local modes = setmetatable({
    ['n'] = { long = 'Normal', short = 'N', hl = { bg = 'mode_normal' } },
    ['v'] = { long = 'Visual', short = 'V', hl = { bg = 'mode_visual' } },
    ['V'] = { long = 'V-Line', short = 'V-L', hl = { bg = 'mode_visual' } },
    [CTRL_V] = { long = 'V-Block', short = 'V-B', hl = { bg = 'mode_visual' } },
    ['s'] = { long = 'Select', short = 'S', hl = { bg = 'mode_visual' } },
    ['S'] = { long = 'S-Line', short = 'S-L', hl = { bg = 'mode_visual' } },
    [CTRL_S] = { long = 'S-Block', short = 'S-B', hl = { bg = 'mode_visual' } },
    ['i'] = { long = 'Insert', short = 'I', hl = { bg = 'mode_insert' } },
    ['R'] = { long = 'Replace', short = 'R', hl = { bg = 'mode_replace' } },
    ['c'] = { long = 'Command', short = 'C', hl = { bg = 'mode_command' } },
    ['r'] = { long = 'Prompt', short = 'P', hl = { bg = 'mode_other' } },
    ['!'] = { long = 'Shell', short = 'Sh', hl = { bg = 'mode_other' } },
    ['t'] = { long = 'Terminal', short = 'T', hl = { bg = 'mode_other' } },
  }, {
    __index = function() return { long = 'Unknown', short = 'U', hl = { bg = 'mode_other' } } end,
  })

  local Mode = {
    init = function(self) self.mode = vim.fn.mode() end,
    condition = is_active,
    hl = function(self)
      local bg = modes[self.mode].hl.bg
      return { fg = 'active_bg', bg = bg }
    end,
    {
      flexible = priority.mode,
      { provider = function(self) return ' ' .. modes[self.mode].long .. ' ' end },
      { provider = function(self) return ' ' .. modes[self.mode].short .. ' ' end },
    },
  }

  local Branch = {
    condition = function() return vim.b.gitsigns_head end,
    {
      flexible = priority.branch,
      { provider = function() return ' ' .. icons.branch .. ' ' .. vim.b.gitsigns_head end },
      { provider = function() return ' ' .. icons.branch end },
    },
  }

  local Diff = {
    condition = function(self)
      local status = vim.b.gitsigns_status_dict
      if not status then return false end
      self.added, self.changed, self.removed = status.added, status.changed, status.removed
      return true
    end,
    {
      flexible = priority.diff,
      {
        {
          provider = function() return ' ' .. icons.diff end,
          {
            condition = function(self)
              return not (self.added and self.changed and self.removed)
                or (self.added == 0 and self.changed == 0 and self.removed == 0)
            end,
            provider = function() return ' ' .. icons.minus end,
          },
        },
        {
          condition = function(self) return self.removed and self.removed > 0 end,
          hl = function()
            if is_active() then return { fg = 'git_minus' } end
          end,
          Space,
          { provider = function(self) return icons.minus .. self.removed end },
        },
        {
          condition = function(self) return self.changed and self.changed > 0 end,
          hl = function()
            if is_active() then return { fg = 'git_delta' } end
          end,
          Space,
          { provider = function(self) return icons.delta .. self.changed end },
        },
        {
          condition = function(self) return self.added and self.added > 0 end,
          hl = function()
            if is_active() then return { fg = 'git_plus' } end
          end,
          Space,
          { provider = function(self) return icons.plus .. self.added end },
        },
      },
      { provider = '' },
    },
  }

  local diagnostic_is_enabled = function() return vim.diagnostic.is_enabled({ bufnr = 0 }) end
  local diagnostic_get_count = function() return vim.diagnostic.count(0) end
  local has_diagnostics = function() return diagnostic_is_enabled() and #diagnostic_get_count() > 0 end

  local Diagnostic = {
    condition = has_diagnostics,
    {
      flexible = priority.diag,
      {
        { provider = function() return ' ' .. icons.diag end },
        {
          condition = function(self)
            self.errors = diagnostic_get_count()[vim.diagnostic.severity['ERROR']]
            return self.errors and self.errors > 0
          end,
          hl = function()
            if is_active() then return { fg = 'diag_error' } end
          end,
          Space,
          { provider = function(self) return icons.error .. tostring(self.errors) end },
        },
        {
          condition = function(self)
            self.warn = diagnostic_get_count()[vim.diagnostic.severity['WARN']]
            return self.warn and self.warn > 0
          end,
          hl = function()
            if is_active() then return { fg = 'diag_warn' } end
          end,
          Space,
          { provider = function(self) return icons.warn .. tostring(self.warn) end },
        },
        {
          condition = function(self)
            self.info = diagnostic_get_count()[vim.diagnostic.severity['INFO']]
            return self.info and self.info > 0
          end,
          hl = function()
            if is_active() then return { fg = 'diag_info' } end
          end,
          Space,
          { provider = function(self) return icons.info .. tostring(self.info) end },
        },
        {
          condition = function(self)
            self.hint = diagnostic_get_count()[vim.diagnostic.severity['HINT']]
            return self.hint and self.hint > 0
          end,
          hl = function()
            if is_active() then return { fg = 'diag_hint' } end
          end,
          Space,
          { provider = function(self) return icons.hint .. tostring(self.hint) end },
        },
      },
      { provider = '' },
    },
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
    condition = function() return is_active() and get_attached_lsp() ~= '' end,
    {
      flexible = priority.lsp,
      {
        Space,
        {
          provider = function()
            local attached = get_attached_lsp()
            return icons.lsp .. ' ' .. attached
          end,
        },
      },
      { provider = '' },
    },
  }

  local sep = package.config:sub(1, 1)

  local Filename = {
    init = function(self)
      local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
      local file = vim.fn.expand('%:t')

      if path == '.' or file == '' then
        path = ''
      else
        path = path .. sep
      end
      if
        vim.list_contains({ 'help' }, vim.bo.filetype)
        or vim.list_contains({ 'terminal', 'nofile' }, vim.bo.buftype)
      then
        path = ''
      end
      if file == '' then file = '[No Name]' end
      self.path = path
      self.file = file

      self.suffix = vim.bo.readonly and icons.ro or vim.bo.modified and icons.mod or ''
    end,
    condition = function(self) return self.path ~= '' or self.file ~= '' or self.suffix ~= '' end,
    {
      { Space },
      {
        flexible = priority.path,
        hl = function()
          if is_active() then return { fg = 'path_fg' } end
        end,
        { provider = function(self) return self.path end },
        { provider = function(self) return vim.fn.pathshorten(self.path, 2) end },
        { provider = '' },
      },
      {
        hl = function()
          if is_active() then return { fg = 'active_fg' } end
        end,
        provider = function(self) return self.file end,
      },
      {
        condition = function(self) return self.suffix ~= '' end,
        hl = function()
          if is_active() then return { fg = 'diag_warn' } end
        end,
        provider = function(self) return ' ' .. self.suffix end,
      },
      Space,
    },
  }

  local Macro = {
    condition = is_active,
    provider = function()
      if vim.fn.reg_recording() == '' then return '' end
      return '[' .. vim.fn.reg_recording() .. '] '
    end,
  }

  local Keymap = {
    condition = function()
      local show = vim.b.keymap_name
        and (
          vim.o.imsearch ~= -1 and vim.fn.mode() == 'c' and vim.o.imsearch == 1
          or vim.o.iminsert == 1
        )
      return is_active() and show
    end,
    provider = function() return string.upper(vim.b.keymap_name) .. ' ' end,
  }

  local get_filesize = function()
    local size = vim.fn.getfsize(vim.fn.getreg('%'))
    if size < 1024 then
      return string.format('%dB', size)
    elseif size < 1048576 then
      return string.format('%.2fKiB', size / 1024)
    else
      return string.format('%.2fMiB', size / 1048576)
    end
  end

  local FileInfo = {
    condition = function() return is_active() and vim.bo.filetype ~= '' end,
    hl = { bg = 'devinfo_bg' },
    {
      flexible = priority.fileinfo,
      {
        provider = function()
          local filetype = vim.bo.filetype
          local icon = require('mini.icons').get('filetype', filetype)
          local encoding = vim.bo.fileencoding or vim.bo.encoding
          local format = vim.bo.fileformat
          local size = get_filesize()

          return (' %s %s %s[%s] %s '):format(icon, filetype, encoding, format, size)
        end,
      },
      {
        provider = function()
          local filetype = vim.bo.filetype
          local icon = require('mini.icons').get('filetype', filetype)

          return (' %s %s '):format(icon, filetype)
        end,
      },
      { provider = '' },
    },
  }

  local Search = {
    init = function(self) self.mode = vim.fn.mode() end,
    condition = function() return is_active() and vim.v.hlsearch == 1 end,
    hl = function(self)
      local bg = modes[self.mode].hl.bg
      return { fg = 'active_bg', bg = bg }
    end,
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

  local Location = {
    init = function(self) self.mode = vim.fn.mode() end,
    condition = is_active,
    hl = function(self)
      local bg = modes[self.mode].hl.bg
      return { fg = 'active_bg', bg = bg }
    end,
    {
      flexible = priority.location,
      { provider = ' %l|%L│%2v|%-2{virtcol("$") - 1} ' },
      { provider = ' %l│%2v ' },
    },
  }

  local DevInfo = {
    hl = function()
      if is_active() then
        return { bg = 'devinfo_bg' }
      else
        return { bg = 'inactive_bg' }
      end
    end,
    Branch,
    Diff,
    Diagnostic,
    Lsp,
    {
      condition = function()
        return get_attached_lsp() ~= ''
          or has_diagnostics()
          or vim.b.gitsigns_status_dict
          or vim.b.gitsigns_head
      end,
      Space,
    },
  }

  local Trunc = { provider = '%<' }
  local Align = { provider = '%=' }

  local Statusline = {
    hl = function()
      if is_active() then
        return { fg = 'active_fg', bg = 'active_bg' }
      else
        return { fg = 'inactive_fg', bg = 'inactive_bg' }
      end
    end,
    Mode,
    DevInfo,
    Trunc,
    Filename,
    Align,
    Macro,
    Keymap,
    FileInfo,
    Search,
    Location,
  }

  vim.cmd([[
    function TabPrev(...)
      tabprevious
    endfunction

    function TabNext(...)
      tabnext
    endfunction
  ]])

  local enough_tabs = function() return vim.fn.tabpagenr('$') > 1 end

  local TabPrev = {
    condition = enough_tabs,
    hl = { bg = 'tabpage_bg' },
    provider = function() return (' %%@TabPrev@%s%%X'):format(icons.tabprevious) end,
  }

  local TabCount = {
    hl = { bg = 'tabpage_bg' },
    provider = function()
      local n_tabpages = vim.fn.tabpagenr('$')
      local cur_tabpagenr = vim.fn.tabpagenr()
      local tabpage_section = (' Tab %s/%s '):format(cur_tabpagenr, n_tabpages)
      return tabpage_section
    end,
  }

  local TabNext = {
    condition = enough_tabs,
    hl = { bg = 'tabpage_bg' },
    provider = function() return ('%%@TabNext@%s%%X '):format(icons.tabnext) end,
  }

  local Close = {
    condition = enough_tabs,
    provider = function() return '%999X' .. icons.x end,
  }

  local Tabline = {
    hl = { fg = 'tabpage_fg', bg = 'tabpage_fill' },
    TabPrev,
    TabCount,
    TabNext,
    Align,
    Close,
  }

  local colors = function()
    local get_hl = function(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
    local colors = {
      active_bg = get_hl('StatusLine').bg or 'NONE',
      active_fg = get_hl('StatusLine').fg,

      devinfo_bg = get_hl('TabLineSel').bg or 'NONE',

      inactive_bg = get_hl('StatusLineNC').bg or 'NONE',
      inactive_fg = get_hl('StatusLineNC').fg,

      path_fg = get_hl('Comment').fg,

      diag_hint = get_hl('DiagnosticHint').fg,
      diag_info = get_hl('DiagnosticInfo').fg,
      diag_warn = get_hl('DiagnosticWarn').fg,
      diag_error = get_hl('DiagnosticError').fg,

      git_plus = get_hl('DiagnosticOk').fg,
      git_delta = get_hl('DiagnosticWarn').fg,
      git_minus = get_hl('DiagnosticError').fg,

      mode_normal = get_hl('Function').fg,
      mode_insert = get_hl('String').fg,
      mode_visual = get_hl('Keyword').fg,
      mode_command = get_hl('Operator').fg,
      mode_replace = get_hl('Constant').fg,
      mode_other = get_hl('Type').fg,

      tabpage_bg = get_hl('Search').bg or 'NONE',
      tabpage_fg = get_hl('Search').fg,
      tabpage_fill = get_hl('TabLineFill').bg or 'NONE',
    }
    return colors
  end

  require('heirline').setup({
    statusline = Statusline,
    tabline = Tabline,
    opts = {
      colors = colors,
    },
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

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function() require('heirline.utils').on_colorscheme(colors) end,
    group = vim.api.nvim_create_augroup('HeirlineColors', {}),
  })
end)
