return {
  'hrsh7th/nvim-cmp',

  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-buffer' },
    { 'lukas-reineke/cmp-under-comparator' },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
  },

  event = { 'InsertEnter', 'CmdLineEnter' },

  opts = {
    symbol_map = {
      Text = '',
      Method = '󰆧',
      Function = '󰊕',
      Constructor = '',
      Field = '󰇽',
      Variable = '󰂡',
      Class = '󰠱',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰅲',
      VimCommand = '',
    },
    window_border = {
      border = 'none',
      winhighlight = 'Normal:NormalFloat,CursorLine:Visual,Search:None',
    },
  },

  config = function(_, opts)
    local cmp = require('cmp')
    local compare = cmp.config.compare

    local win_opts = cmp.config.window.bordered(opts.window_border)

    cmp.setup({
      -- preselect = cmp.PreselectMode.None,
      window = {
        completion = win_opts,
        documentation = win_opts,
        col_offset = -3,
        side_padding = 0,
      },
      mapping = {
        ['<c-u>'] = cmp.mapping.scroll_docs(-4),
        ['<c-d>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
        ['<c-e>'] = cmp.mapping.close(),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
        ['<c-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        --[[
      ['<tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<s-tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ]]
      },
      snippet = {
        --[[
      expand = function(args)
        require('snippy').expand_snippet(args.body)
      end,
      ]]
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      sources = {
        { name = 'luasnip' },
        -- { name = 'snippy' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        {
          name = 'buffer',
          keyword_length = 4,
          option = {
            keyword_pattern = [[\k\+]],
          },
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              table.insert(bufs, vim.api.nvim_win_get_buf(win))
            end
            return bufs
          end,
        },
      },
      sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          require('cmp-under-comparator').under,
          -- compare.locality,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local symbol_map = opts.symbol_map
          if entry.source.name == 'cmdline' then
            vim_item.kind = ' ' .. symbol_map.VimCommand .. ' '
            return vim_item
          end
          local kind_name = vim_item.kind
          vim_item.kind = ' ' .. symbol_map[kind_name] .. ' '
          vim_item.menu = ' (' .. kind_name .. ')'
          return vim_item
        end,
      },
      experimental = {
        native_menu = false,
        ghost_text = true,
      },
    })

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
