local conditions = require('heirline.conditions')
local icons = require('plugins.heirline.symbols').icons

-- Diagnostic icon style
local dia_style = require('plugins.heirline.config').dia_style
local git_style = require('plugins.heirline.config').git_style

local Align = { provider = '%=' }
local Space = setmetatable({ provider = ' ' }, {
  __call = function(_, opts)
    local space = { provider = string.rep(' ', opts.n or 1) }
    if opts.phony then
      space.on_click = {
        name = 'heirline_phony',
        callback = function() end,
      }
    end
    return space
  end,
})
local null = { provider = '' }

local hl = require('plugins.heirline.colors')
local devicons = require('nvim-web-devicons')

local priority = {
  FileIcon = 80,
  CurrentPath = 40,
  FileType = 20,
  Navic = 10,
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
  end,
  {
    flexible = priority.FileIcon,
    {
      provider = function(self)
        return self.icon
      end,
    },
    null,
  },
  hl = function(self)
    return { fg = self.icon_color }
  end,
  Space,
}

local FileType = {
  init = function(self)
    self.filetype = vim.bo.filetype
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    _, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
  end,
  {

    flexible = priority.FileType,
    {
      provider = function(self)
        return self.filetype
      end,
    },
    null,
  },
  hl = function(self)
    return { fg = self.icon_color }
  end,
  Space,
}

local CurrentPath = {
  condition = function(self)
    return self.current_path ~= ''
  end,
  {
    flexible = priority.CurrentPath,
    {
      provider = function(self)
        return self.current_path
      end,
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.current_path, 2)
      end,
    },
    null,
  },
  hl = hl.CurrentPath,
}

local FileName = {
  provider = function(self)
    return self.filename
  end,
  hl = hl.FileName,
  Space,
}

local FileModified = {
  condition = function()
    return vim.bo.modified
  end,
  provider = icons.small_circle,
  hl = hl.ModeColors.modified,
  Space,
}

local FileNameBlock = {
  {
    {
      fallthrough = false,
      {
        condition = function()
          return vim.bo['buftype'] == 'help'
        end,
        null,
      },
      CurrentPath,
    },
    FileName,
    FileIcon,
    FileType,
  },
  { provider = '%<' },
}

local GitChanges = {
  static = {
    changed = icons.git.changed[git_style],
    added = icons.git.added[git_style],
    removed = icons.git.removed[git_style],
  },
  condition = function(self)
    self.git_status = vim.b.gitsigns_status_dict
    return self.git_status
      and self.git_status.added
      and self.git_status.changed
      and self.git_status.removed
      and (self.git_status.added > 0 or self.git_status.changed > 0 or self.git_status.removed > 0)
  end,
  init = function(self)
    function self.did_add()
      return self.git_status.added > 0
    end
    function self.did_change()
      return self.git_status.changed > 0
    end
    function self.did_remove()
      return self.git_status.removed > 0
    end
  end,
  {
    provider = '(',
  },
  {
    condition = function(self)
      return self.did_add()
    end,
    provider = function(self)
      local count = self.git_status.added
      return table.concat({ self.added, count })
    end,
    hl = hl.Git.added,
    {
      condition = function(self)
        return self.did_change() or self.did_remove()
      end,
      Space,
    },
  },
  {
    condition = function(self)
      return self.did_change()
    end,
    provider = function(self)
      local count = self.git_status.changed
      return table.concat({ self.changed, count })
    end,
    hl = hl.Git.changed,
    {
      condition = function(self)
        return self.did_remove()
      end,
      Space,
    },
  },
  {
    condition = function(self)
      return self.did_remove()
    end,
    provider = function(self)
      local count = self.git_status.removed
      return table.concat({ self.removed, count })
    end,
    hl = hl.Git.removed,
  },
  {
    provider = ')',
  },
  Space({ phony = true }),
  on_click = {
    minwid = function()
      return vim.api.nvim_get_current_win()
    end,
    callback = function(_, minwid)
      vim.api.nvim_set_current_win(minwid)
      require('gitsigns').next_hunk()
    end,
    name = 'heirline_git_bar',
  },
}

local callback = function(self, minwid)
  local winid, severity = self.dec(minwid)
  vim.api.nvim_set_current_win(winid)
  vim.diagnostic.goto_next({
    float = true,
    win_id = winid,
    severity = severity,
  })
end

local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { 'DiagnosticChanged', 'BufEnter' },
  static = {
    error_icon = icons.diagnostic.error[dia_style],
    warn_icon = icons.diagnostic.warn[dia_style],
    info_icon = icons.diagnostic.info[dia_style],
    hint_icon = icons.diagnostic.hint[dia_style],
    enc = function(winid, severity)
      return bit.bor(bit.lshift(winid, 3), severity)
    end,
    dec = function(c)
      local winid = bit.rshift(c, 3)
      local severity = bit.band(c, 7)
      return winid, severity
    end,
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    function self.has_errors()
      return self.errors > 0
    end
    function self.has_warnings()
      return self.warnings > 0
    end
    function self.has_info()
      return self.info > 0
    end
    function self.has_hints()
      return self.hints > 0
    end
  end,
  {
    provider = '[',
  },
  {
    condition = function(self)
      return self.has_errors()
    end,
    provider = function(self)
      return table.concat({ self.error_icon, self.errors })
    end,
    hl = hl.Diagnostic.error,
    {
      condition = function(self)
        return self.has_warnings() or self.has_info() or self.has_hints()
      end,
      Space({ phony = true }),
    },
    on_click = {
      minwid = function(self)
        return self.enc(vim.api.nvim_get_current_win(), vim.diagnostic.severity.ERROR)
      end,
      name = 'heirline_diagnostic',
      callback = callback,
    },
  },
  {
    condition = function(self)
      return self.has_warnings()
    end,
    provider = function(self)
      return table.concat({ self.warn_icon, self.warnings })
    end,
    hl = hl.Diagnostic.warn,
    {
      condition = function(self)
        return self.has_info() or self.has_hints()
      end,
      Space({ phony = true }),
    },
    on_click = {
      minwid = function(self)
        return self.enc(vim.api.nvim_get_current_win(), vim.diagnostic.severity.WARN)
      end,
      name = 'heirline_diagnostic',
      callback = callback,
    },
  },
  {
    condition = function(self)
      return self.has_info()
    end,
    provider = function(self)
      return table.concat({ self.info_icon, self.info })
    end,
    hl = hl.Diagnostic.info,
    {
      condition = function(self)
        return self.has_hints()
      end,
      Space({ phony = true }),
    },

    on_click = {
      minwid = function(self)
        return self.enc(vim.api.nvim_get_current_win(), vim.diagnostic.severity.INFO)
      end,
      name = 'heirline_diagnostic',
      callback = callback,
    },
  },
  {
    condition = function(self)
      return self.has_hints()
    end,
    provider = function(self)
      return table.concat({ self.hint_icon, self.hints })
    end,
    hl = hl.Diagnostic.hint,

    on_click = {
      minwid = function(self)
        return self.enc(vim.api.nvim_get_current_win(), vim.diagnostic.severity.HINT)
      end,
      name = 'heirline_diagnostic',
      callback = callback,
    },
  },
  {
    provider = ']',
  },
  Space({ phony = true }),
}

local Navic = {}
do
  local ok, navic = pcall(require, 'nvim-navic')
  if ok then
    Navic = {
      condition = function()
        return navic.is_available()
      end,
      update = { 'CursorMoved', 'CursorMovedI' },
      static = {
        type_hl = {
          File = 'Directory',
          Module = '@include',
          Namespace = '@namespace',
          Package = '@include',
          Class = '@structure',
          Method = '@method',
          Property = '@property',
          Field = '@field',
          Constructor = '@constructor',
          Enum = '@field',
          Interface = '@type',
          Function = '@function',
          Variable = '@variable',
          Constant = '@constant',
          String = '@string',
          Number = '@number',
          Boolean = '@boolean',
          Array = '@field',
          Object = '@type',
          Key = '@keyword',
          Null = '@comment',
          EnumMember = '@field',
          Struct = '@structure',
          Event = '@keyword',
          Operator = '@operator',
          TypeParameter = '@type',
        },
        enc = function(line, col, winnr)
          return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        dec = function(c)
          local line = bit.rshift(c, 16)
          local col = bit.band(bit.rshift(c, 6), 1023)
          local winnr = bit.band(c, 63)
          return line, col, winnr
        end,
      },
      init = function(self)
        local function click_callback(_, minwid)
          local line, col, winnr = self.dec(minwid)
          vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
        end

        local data = navic.get_data() or {}
        local children = {}
        for i, d in ipairs(data) do
          local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
          local child = {
            flexible = true,
            {
              {
                provider = d.icon,
                hl = self.type_hl[d.type],
                on_click = {
                  minwid = pos,
                  callback = click_callback,
                  name = 'heirline_navic_icon',
                },
              },
              {
                provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
                on_click = {
                  minwid = pos,
                  callback = click_callback,
                  name = 'heirline_navic_text',
                },
              },
            },
          }
          if #data > 1 and i < #data then
            table.insert(child[1], {
              provider = ' > ',
              hl = { fg = 'white' },
            })
          end
          table.insert(children, child)
        end
        self.child = self:new(children, 1)
      end,
      {
        flexible = priority.Navic,
        {
          Space,
          {
            provider = function(self)
              return self.child:eval()
            end,
          },
          Space,
        },
        null,
      },
      hl = { fg = 'white' },
    }
  end
end

local TerminalIcon = {
  {
    flexible = priority.FileIcon,
    {
      provider = ' ',
      hl = hl.TerminalIcon,
    },
    null,
  },
}

local TerminalName = {
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
    return vim.fn.fnamemodify(tname, ':t')
  end,
  hl = hl.TerminalName,
  Space,
}

local TerminalBlock = {
  TerminalName,
  TerminalIcon,
}

local os_sep = package.config:sub(1, 1)
local winbar = {
  init = function(self)
    local pwd = vim.fn.getcwd(0)
    local current_path = vim.api.nvim_buf_get_name(0)
    local filename

    if current_path == '' then
      filename = '[No Name]'
    elseif current_path:find(pwd, 1, true) then
      filename = vim.fn.fnamemodify(current_path, ':t')
      current_path = vim.fn.fnamemodify(current_path, ':~:.:h')
      if current_path == '.' then
        current_path = ''
      else
        current_path = current_path .. os_sep
      end
    else
      filename = vim.fn.fnamemodify(current_path, ':t')
      current_path = vim.fn.fnamemodify(current_path, ':~:.:h') .. os_sep
    end

    self.current_path = current_path
    self.filename = filename
  end,
  fallthrough = false,
  {
    condition = function()
      return conditions.buffer_matches({ buftype = { 'terminal' } })
    end,
    Align,
    TerminalBlock,
    hl = hl.WinBar,
  },
  {
    Navic,
    Align,
    Diagnostics,
    GitChanges,
    FileNameBlock,
    FileModified,
    hl = hl.WinBar,
  },
}

return { WinBar = winbar }
