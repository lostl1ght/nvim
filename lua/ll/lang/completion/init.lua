local lspkind, luasnip, cmp
local k, s, c
k, lspkind = pcall(require, 'lspkind')
s, luasnip = pcall(require, 'luasnip')
c, cmp = pcall(require, 'cmp')
if not k or not s or not c then
    return print('lspkind or luasnip or cmp not found')
end

local cmp_buffer = require('cmp_buffer')
-- Completion settings
vim.o.completeopt = 'menu,menuone,noselect'
cmp.setup({
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ['<A-n>'] = function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end,
        ['<A-p>'] = function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lua' },
        { name = 'vim-dadbod-completion' },
        { name = 'path' },
        {
            name = 'buffer',
            keyword_length = 5,
            option = {
                keyword_pattern = [[\k\+]],
            },
            get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
            end,
        },
    },
    sorting = {
        comparators = {
            function(...)
                return cmp_buffer:compare_locality(...)
            end,
        },
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                buffer = '[buf]',
                nvim_lsp = '[lsp]',
                nvim_lua = '[api]',
                path = '[path]',
                luasnip = '[snip]',
            },
        }),
    },
    experimental = {
        native_menu = false,

        ghost_text = true,
    },
})
