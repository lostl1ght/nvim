local ls = require('luasnip')
local c = require('mars.snippet.c')

ls.filetype_extend('cpp', {'c'})
ls.snippets = {
    c = c,
}

