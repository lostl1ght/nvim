local present, ls = pcall(require, 'luasnip')
if not present then
    return
end
local c = require('lostlight.snippet.c')

ls.filetype_extend('cpp', {'c'})
ls.snippets = {
    c = c,
}

