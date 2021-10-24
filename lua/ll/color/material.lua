local present, material = pcall(require, 'material')
if not present then
    return print('material not found')
end
-- Color scheme
vim.o.termguicolors = true
vim.o.cursorline = true
vim.g.material_style = vim.g.color_theme
vim.cmd('colorscheme material')

