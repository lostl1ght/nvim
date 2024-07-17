local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

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

later(function()
  add({
    source = 'L3MON4D3/LuaSnip',
    hooks = {
      post_install = function(spec)
        later(function()
          -- stylua: ignore
          require('util').build_package({
            'make',    '-C',
            spec.path, 'install_jsregexp',
          }, spec)
        end)
      end,
    },
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  local set = vim.keymap.set
  set({ 'i', 's' }, '<c-f>', function()
    if require('luasnip').jumpable() then require('luasnip').jump(1) end
  end)
  set({ 'i', 's' }, '<c-b>', function()
    if require('luasnip').jumpable(-1) then require('luasnip').jump(-1) end
  end)
end)

later(function()
  add({
    source = 'hrsh7th/nvim-cmp',
    depends = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'lukas-reineke/cmp-under-comparator',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'windwp/nvim-autopairs',
      'https://codeberg.org/FelipeLema/cmp-async-path',
    },
  })
  local cmp = require('cmp')
  local compare = cmp.config.compare

  cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered({
        border = 'none',
        winhighlight = 'Normal:NormalFloat,CursorLine:Visual,Search:None',
      }),
      documentation = cmp.config.window.bordered({
        border = vim.g.border,
        winhighlight = 'Normal:NormalFloat,CursorLine:Visual,Search:None',
      }),
    },
    mapping = {
      ['<c-u>'] = cmp.mapping.scroll_docs(-4),
      ['<c-d>'] = cmp.mapping.scroll_docs(4),
      ['<c-space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
      ['<c-e>'] = cmp.mapping.close(),
      ['<c-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<c-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ['<cr>'] = cmp.mapping.confirm({ select = true }),
    },
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'async_path' },
      {
        name = 'buffer',
        keyword_length = 4,
        option = {
          keyword_pattern = [[\k\+]],
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      {
        name = 'lazydev',
        group_index = 0,
      },
    },
    sorting = {
      comparators = {
        compare.offset,
        compare.exact,
        compare.score,
        require('cmp-under-comparator').under,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, item)
        local miniicons = require('mini.icons')
        if entry.source.name ~= 'cmdline' then
          ---@type string
          local kind = item.kind or 'default'
          item.kind = (' %s '):format(miniicons.get('lsp', kind))
          item.menu = ('(%s)'):format(kind:gsub('(%a)(%u)', '%1 %2'):lower())
        else
          item.kind = (' %s '):format(miniicons.get('file', 'init.lua'))
        end
        return item
      end,
    },
    experimental = {
      ghost_text = false,
    },
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline({
      ['<tab>'] = { c = function() end },
      ['<s-tab>'] = { c = function() end },
    }),
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
      ['<tab>'] = { c = function() end },
      ['<s-tab>'] = { c = function() end },
    }),
    sources = cmp.config.sources({
      { name = 'async_path' },
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' },
        },
      },
    }),
  })

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end)
