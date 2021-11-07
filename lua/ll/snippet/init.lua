local present, ls = pcall(require, 'luasnip')
if not present then
    return print('luasnip not found')
end
local c = require('ll.snippet.c')

ls.filetype_extend('cpp', { 'c' })
ls.snippets = {
    c = c,
}
