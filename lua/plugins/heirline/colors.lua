local hl = {
  -- statusline
  StatusLine = {
    fg = 'white',
    bg = 'bg',
    bold = true,
  },

  -- HostName = { fg = 'blue' },

  ReadOnly = { fg = 'red' },

  SearchResults = { fg = 'black', bg = 'blue', bold = false },

  WorkDir = { fg = 'gray', bold = true },

  LspIndicator = { fg = 'blue' },

  LspServer = { fg = 'blue', bold = true },

  Layout = { fg = 'red' },

  ScrollBar = {
    bg = 'bg',
    fg = 'white',
  },

  MacroRec = {
    Component = { fg = 'yellow', bold = false },
    Register = { fg = 'green', bold = true },
  },

  LazyUpdates = { fg = 'red' },

  EscapeWaiting = { fg = 'yellow' },

  -- winbar
  WinBar = { bg = 'bg' },

  CurrentPath = { fg = 'green', bold = true },

  FileName = {
    fg = 'white',
    bold = true,
  },

  Git = {
    branch = { fg = 'teal', bold = true },
    added = { fg = 'green', bold = true },
    changed = { fg = 'yellow', bold = true },
    removed = { fg = 'red', bold = true },
  },

  Diagnostic = {
    error = { fg = 'red' },
    warn = { fg = 'yellow' },
    info = { fg = 'blue' },
    hint = { fg = 'green' },
  },

  TerminalIcon = {
    fg = 'gray',
  },

  TerminalName = {
    fg = 'white',
    bold = true,
  },

  -- tabline
  TabLine = { bg = 'bg' },

  TabNumber = function(self)
    if not self.is_active then
      return { fg = 'gray' }
    else
      return { fg = 'white', bold = true }
    end
  end,

  TabpageClose = function(self)
    if not self.is_active then
      return { fg = 'gray' }
    else
      return { fg = 'white' }
    end
  end,

  VerticalLine = function(self)
    if not self.is_active then
      return { fg = 'gray' }
    else
      return { fg = 'yellow' }
    end
  end,

  WinCount = function(self)
    if not self.is_active then
      return { fg = 'gray', bold = true }
    else
      return { fg = 'yellow' }
    end
  end,

  ActiveFile = function(self)
    if not self.is_active then
      return { fg = 'gray' }
    else
      return { fg = 'white', bold = true }
    end
  end,
}

local mode_colors = {
  normal = 'white',
  op = 'blue',
  insert = 'green',
  visual = 'yellow',
  visual_lines = 'yellow',
  visual_block = 'yellow',
  replace = 'red',
  v_replace = 'red',
  enter = 'blue',
  more = 'blue',
  select = 'teal',
  command = 'blue',
  shell = 'yellow',
  terminal = 'yellow',
  confirm = 'white',
  none = 'red',
}

hl.ModeColors = setmetatable({
  normal = { fg = mode_colors.normal },
  modified = { fg = 'red' },
}, {
  __index = function(_, mode)
    return {
      fg = 'black',
      bg = mode_colors[mode],
      bold = true,
    }
  end,
})

return hl
