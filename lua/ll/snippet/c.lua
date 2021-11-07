local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local c = {
    s('for', {
        t('for ('),
        i(1, 'init-expression'),
        t('; '),
        i(2, 'cond-expression'),
        t('; '),
        i(3, 'loop-expression'),
        t({ ') {', '\t' }),
        i(4, 'statement'),
        t({ '', '}' }),
    }),
    s('return', {
        t('return '),
        i(1, 'extension'),
        t(';'),
    }),
    s('while', {
        t('while ('),
        i(1, 'expression'),
        t({ ') {', '\t' }),
        i(2, 'statement'),
        t({ '', '}' }),
    }),
    s('define', {
        t('#define '),
        i(1, 'identifier'),
        t(' '),
        i(2, 'token-string'),
    }),
}

return c
