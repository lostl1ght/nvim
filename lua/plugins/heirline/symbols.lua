local icons = {}

icons.icons = {
  powerline = {
    left = {
      round = '',
      angular = '█',
    },
    right = {
      round = '',
      angular = '█',
    },
  },
  diagnostic = {
    error = {
      text = 'e:',
      hollow = ' ',
      whole = ' ',
    },
    warn = {
      text = 'w:',
      hollow = ' ',
      whole = ' ',
    },
    info = {
      text = 'i:',
      hollow = ' ',
      whole = ' ',
    },
    hint = {
      text = 'h:',
      hollow = '',
      whole = '󰌵',
    },
  },
  git = {
    added = {
      text = '+',
    },
    changed = {
      text = '~',
    },
    removed = {
      text = '-',
    },
  },
  padlock = '',
  circle = '',
  small_circle = '●',
  server = '',
  cross = '',
  bufferline = {
    left = ' ',
    right = ' ',
  },
}

icons.mode = setmetatable({
  n = 'normal',
  no = 'op',
  nov = 'op',
  noV = 'op',
  ['no'] = 'op',
  niI = 'normal',
  niR = 'normal',
  niV = 'normal',
  nt = 'normal',
  v = 'visual',
  V = 'visual_lines',
  [''] = 'visual_block',
  s = 'select',
  S = 'select',
  [''] = 'block',
  i = 'insert',
  ic = 'insert',
  ix = 'insert',
  R = 'replace',
  Rc = 'replace',
  Rv = 'v_replace',
  Rx = 'replace',
  c = 'command',
  cv = 'command',
  ce = 'command',
  r = 'enter',
  rm = 'more',
  ['r?'] = 'confirm',
  ['!'] = 'shell',
  t = 'terminal',
  ['null'] = 'none',
}, {
  __call = function(self, raw_mode)
    return self[raw_mode]
  end,
})

icons.mode_label = {
  normal = 'NORMAL',
  op = 'OP',
  visual = 'VISUAL',
  visual_lines = 'VISUAL LINES',
  visual_block = 'VISUAL BLOCK',
  select = 'SELECT',
  block = 'BLOCK',
  insert = 'INSERT',
  replace = 'REPLACE',
  v_replace = 'V-REPLACE',
  command = 'COMMAND',
  enter = 'ENTER',
  more = 'MORE',
  confirm = 'CONFIRM',
  shell = 'SHELL',
  terminal = 'TERMINAL',
  none = 'NONE',
}

return icons
