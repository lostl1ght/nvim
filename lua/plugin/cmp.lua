local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({
    source = 'hrsh7th/nvim-cmp',
    depends = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'lukas-reineke/cmp-under-comparator',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'windwp/nvim-autopairs',
    },
  })
  local cmp = require('cmp')
  local compare = cmp.config.compare

  local win_opts = cmp.config.window.bordered({
    border = 'none',
    winhighlight = 'Normal:NormalFloat,CursorLine:Visual,Search:None',
  })

  cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    window = {
      completion = win_opts,
      documentation = win_opts,
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
      { name = 'path' },
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
        local mini_icons = require('mini.icons')
        if entry.source.name ~= 'cmdline' then
          ---@type string
          local kind = item.kind or 'default'
          item.kind = (' %s '):format(mini_icons.get('lsp', kind))
          item.menu = ('(%s)'):format(kind:gsub('(%a)(%u)', '%1 %2'):lower())
        else
          item.kind = (' %s '):format(mini_icons.get('file', 'init.lua'))
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
      { name = 'path' },
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
