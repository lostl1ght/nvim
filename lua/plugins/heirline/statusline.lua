local hl = require('plugins.heirline.colors')
local symbols = require('plugins.heirline.symbols')
local icons = symbols.icons
local mode_colors = hl.ModeColors
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

-- Separator style
local separator = require('plugins.heirline.config').separator

local priority = {
  WorkDir = 60,
  GitBranch = 50,
  Lsp = 40,
  Ruler = 30,
  ScrollBar = 20,
  HostName = 10,
}

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

--[[
local HostName = {
  flexible = priority.HostName,
  {
    provider = function()
      return vim.fn.hostname()
    end,
    hl = hl.HostName,
    Space,
  },
  null,
}
]]

local ReadOnly = {
  condition = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  provider = icons.padlock,
  hl = hl.ReadOnly,
}

local NormalModeIndicator = {
  Space,
  {
    fallthrough = false,
    ReadOnly,
    {
      provider = icons.circle,
      hl = function()
        if vim.bo.modified then
          return mode_colors.modified
        else
          return mode_colors.normal
        end
      end,
    },
  },
  Space,
}

local VimModeNormal = {
  condition = function(self)
    return self.mode == 'normal'
  end,
  NormalModeIndicator,
}

local VimModeActive = {
  condition = function(self)
    return self.mode ~= 'normal'
  end,
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      vim.cmd('redrawstatus')
    end),
  },
  hl = { bg = hl.StatusLine.bg },
  utils.surround(
    { icons.powerline.left[separator], icons.powerline.right[separator] },
    function(self)
      return mode_colors[self.mode].bg
    end,
    {
      {
        fallthrough = false,
        ReadOnly,
        { provider = icons.circle },
      },
      Space,
      {
        provider = function(self)
          return symbols.mode_label[self.mode]
        end,
      },
      hl = function(self)
        return mode_colors[self.mode]
      end,
    }
  ),
}

local VimMode = {
  init = function(self)
    self.mode = symbols.mode[vim.api.nvim_get_mode().mode]
  end,
  VimModeActive,
  VimModeNormal,
  Space,
}

local SearchResults = {
  condition = function(self)
    if vim.v.hlsearch == 0 or vim.o.cmdheight ~= 0 then
      return false
    end

    local ok, search = pcall(vim.fn.searchcount)
    if not ok or vim.tbl_isempty(search) then
      return false
    end

    local query = vim.fn.getreg('/')
    if query == '' then
      return false
    end

    --[[
    if query:find('@') then
      return false
    end
    ]]

    self.query = table.concat({
      query:gsub([[^\V]], ''):gsub([[\<]], ''):gsub([[\>]], ''):gsub('%%', '%%%%'),
      ' [',
      search.current,
      '/',
      math.min(search.total, search.maxcount),
      ']',
    })
    return true
  end,

  utils.surround(
    { icons.powerline.left[separator], icons.powerline.right[separator] },
    hl.SearchResults.bg,
    {
      provider = function(self)
        return self.query
      end,
      hl = hl.SearchResults,
    }
  ),
  Space,
}

local WorkDir = {
  condition = function(self)
    return self.pwd
  end,
  {
    flexible = priority.WorkDir,
    {
      provider = function(self)
        return self.pwd
      end,
      Space({ phony = true }),
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.pwd)
      end,
      Space({ phony = true }),
    },
    null,
  },
  hl = hl.WorkDir,
  on_click = {
    callback = function()
      require('mini.files').open()
    end,
    name = 'heirline_minifiles',
  },
}

local GitBranch = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.git_status = vim.b.gitsigns_status_dict
  end,
  {
    flexible = priority.GitBranch,
    {
      provider = function(self)
        return ' ' .. self.git_status.head
      end,
      Space({ phony = true }),
    },
    { provider = '' },
  },
  hl = hl.Git.branch,
  on_click = {
    callback = function()
      vim.api.nvim_cmd({ cmd = 'Lg' }, {})
    end,
    name = 'heirline_git_line',
  },
}

local LspIndicator = {
  provider = icons.server,
  hl = hl.LspIndicator,
  Space({ phony = true }),
}

local LspServer = {
  provider = function(self)
    local names = self.lsp_names
    if #names == 1 then
      names = names[1]
    else
      names = table.concat(names, ' ')
    end
    return ' ' .. names
  end,
  Space({ phony = true }),
  hl = hl.LspServer,
}

local Lsp = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  init = function(self)
    local names = {}
    for _, server in ipairs(vim.lsp.get_clients()) do
      table.insert(names, server.name)
    end
    self.lsp_names = names
  end,
  {
    flexible = priority.Lsp,
    LspServer,
    LspIndicator,
  },
  hl = hl.LspServer,
  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd.LspInfo()
      end, 100)
    end,
    name = 'heirline_lsp',
  },
}

local Ruler = {
  -- %-2 : make item takes at least 2 cells and be left justified
  -- %l  : current line number
  -- %L  : number of lines in the buffer
  -- %c  : column number
  -- provider = ' %7(%l:%3L%)  %-2c ',
  {
    flexible = priority.Ruler,
    {
      provider = '%(%l:%L%)  %-2c ',
    },
    null,
  },
  hl = { bold = true },
}

local ScrollBar = {
  static = {
    sbar = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁' },
  },
  {
    flexible = priority.ScrollBar,
    {
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2) .. ' %p%%'
      end,
    },
    null,
  },
  hl = hl.ScrollBar,
  Space,
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
  end,
  provider = ' ',
  hl = hl.MacroRec.Component,
  utils.surround({ '[', '] ' }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = hl.MacroRec.Register,
  }),
}

local Layout = {}
do
  local ok, km_switch = pcall(require, 'keymap_switch')
  if ok then
    Layout = {
      condition = km_switch.condition,
      provider = km_switch.provider,
      hl = hl.Layout,
      Space,
    }
  end
end

--[[
local LazyUpdates = {}
do
  local ok, lazy = pcall(require, 'lazy.status')
  if ok then
    LazyUpdates = {
      condition = lazy.has_updates,
      provider = lazy.updates,
      hl = hl.LazyUpdates,
      on_click = {
        callback = function()
          vim.defer_fn(function()
            vim.cmd.Lazy()
          end, 100)
        end,
        name = 'heirline_update',
      },
      Space({phony=true}),
    }
  end
end
]]
local statusline = {
  init = function(self)
    self.pwd = vim.fn.fnamemodify(vim.uv.cwd() or '', ':~')
  end,
  hl = hl.StatusLine,
  Space,
  VimMode,
  SearchResults,
  -- HostName,
  WorkDir,
  GitBranch,
  Align,
  -- LazyUpdates,
  MacroRec,
  Lsp,
  Layout,
  Ruler,
  ScrollBar,
}

return { StatusLine = statusline }
