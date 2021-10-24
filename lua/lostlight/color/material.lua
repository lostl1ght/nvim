local present, material = pcall(require, 'material')
if not present then
    return
end
-- Color scheme
vim.o.termguicolors = true
vim.o.cursorline = true
-- vim.g.material_style = 'lighter'
-- vim.g.material_style = 'darker'
vim.g.material_style = vim.g.color_theme
vim.cmd('colorscheme material')

