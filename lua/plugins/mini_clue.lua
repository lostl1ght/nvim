---@type LazyPluginSpec
return {
  'echasnovski/mini.clue',
  event = 'VeryLazy',
  config = function()
    local miniclue = require('mini.clue')
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<c-x>' },

        -- `g` key
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

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        -- Brackets
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
        {
          { mode = 'n', keys = '<leader>b', desc = '+buffer' },
          { mode = 'n', keys = '<leader>f', desc = '+file' },
          { mode = 'n', keys = '<leader>p', desc = '+package' },
          { mode = 'n', keys = '<leader>q', desc = '+quit/session' },
          { mode = 'n', keys = '<leader>t', desc = '+toggle' },
        },
      },
      window = {
        delay = 500,
      },
    })
  end,
}
