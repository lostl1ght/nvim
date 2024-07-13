local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'echasnovski/mini.clue' })
  local MiniClue = require('mini.clue')
  MiniClue.setup({
    triggers = {
      -- Built-in completion
      { mode = 'i', keys = '<c-x>' },
      -- g key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<c-r>' },
      { mode = 'c', keys = '<c-r>' },
      -- Window commands
      { mode = 'n', keys = '<c-w>' },
      -- z key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
      -- Brackets
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      -- Toggle
      { mode = 'n', keys = '\\' },
      -- Surround
      { mode = 'n', keys = 'm' },
      { mode = 'x', keys = 'm' },
    },

    clues = {
      MiniClue.gen_clues.builtin_completion(),
      MiniClue.gen_clues.g(),
      MiniClue.gen_clues.marks(),
      MiniClue.gen_clues.registers(),
      MiniClue.gen_clues.windows({ submode_resize = true }),
      MiniClue.gen_clues.z(),
      {
        { mode = 'n', keys = 'gb', desc = '+buffer' },
        { mode = 'n', keys = 'gf', desc = '+file' },
        { mode = 'n', keys = 'gs', desc = '+sessions' },
        { mode = 'n', keys = 'gr', desc = '+code' },
      },
    },
    window = { delay = 500 },
  })
end)
