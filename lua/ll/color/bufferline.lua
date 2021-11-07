local present, line = pcall(require, 'bufferline')
if not present then
    return print('bufferline not found')
end

vim.o.termguicolors = true

line.setup({
    options = {
        separator_style = 'slant',
        modified_icon = '',
    },
})
