local minideps = require('mini.deps')
local add, later, now = minideps.add, minideps.later, minideps.now

later(function()
  add({ source = 'windwp/nvim-autopairs' })

  local apairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')
  local cond = require('nvim-autopairs.conds')
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
    Rule('$', '$', { 'tex', 'latex' })
      :with_pair(cond.not_after_regex('%%'))
      :with_pair(cond.not_before_regex('xxx', 3))
      :with_move(cond.none())
      :with_del(cond.not_after_regex('xx'))
      :with_cr(cond.none()),
  })
  for _, bracket in pairs(brackets) do
    apairs.add_rules({
      Rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(cond.none())
        :with_move(function(opts) return opts.prev_char:match('.%' .. bracket[2]) ~= nil end)
        :use_key(bracket[2]),
    })
  end

  local punctuation = { ',', ';' }
  for _, punct in pairs(punctuation) do
    apairs.add_rules({
      Rule('', punct)
        :with_move(function(opts) return opts.char == punct end)
        :with_pair(cond.none())
        :with_del(cond.none())
        :with_cr(cond.none())
        :use_key(punct),
    })
  end
end)

now(function()
  add({
    source = 'saghen/blink.cmp',
    hooks = {
      post_checkout = require('util').build_package({ 'cargo', 'build', '--release' }),
      post_install = require('util').build_package({ 'cargo', 'build', '--release' }),
    },
  })

  require('blink-cmp').setup({
    signature = { enabled = true },
    fuzzy = { prebuilt_binaries = { download = false } },
    completion = { accept = { auto_brackets = { enabled = true } } },
    sources = { providers = { buffer = { min_keyword_length = 4 } } },
    keymap = {
      preset = 'default',
      ['<cr>'] = { 'select_and_accept', 'fallback' },
      ['<c-b>'] = { 'snippet_backward', 'fallback' },
      ['<c-f>'] = { 'snippet_forward', 'fallback' },
      ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<tab>'] = { 'fallback' },
      ['<s-tab>'] = { 'fallback' },
    },
  })
end)
