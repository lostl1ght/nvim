local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = 'windwp/nvim-autopairs' })

  local apairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')
  apairs.setup({})

  local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
  apairs.add_rules({
    Rule(' ', ' '):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2],
      }, pair)
    end),
  })
  for _, bracket in pairs(brackets) do
    apairs.add_rules({
      Rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(function() return false end)
        :with_move(function(opts) return opts.prev_char:match('.%' .. bracket[2]) ~= nil end)
        :use_key(bracket[2]),
    })
  end

  local punctuation = { ',', ';' }
  for _, punct in pairs(punctuation) do
    apairs.add_rules({
      Rule('', punct)
        :with_move(function(opts) return opts.char == punct end)
        :with_pair(function() return false end)
        :with_del(function() return false end)
        :with_cr(function() return false end)
        :use_key(punct),
    })
  end
end)
