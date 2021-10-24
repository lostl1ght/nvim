local ls = require('luasnip')
local c = require('lostlight.snippet.c')

ls.filetype_extend('cpp', {'c'})
ls.snippets = {
    c = c,
}

