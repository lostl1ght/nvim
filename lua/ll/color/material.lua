local present, material = pcall(require, 'material')
if not present then
    return print('material not found')
end

vim.o.termguicolors = true
vim.o.cursorline = true

vim.g.material_style = llvim.style

material.setup({
    contrast = true,
    borders = true,

    popup_menu = 'colorful', --'dark', 'light', 'colorful' or 'stealth'

    italics = {
        comments = true,
        keywords = false,
        functions = false,
        strings = true,
        variables = false,
    },

    contrast_windows = {
        'terminal',
        'packer',
        'qf',
    },

    text_contrast = {
        lighter = false,
        darker = false,
    },

    disable = {
        background = false,
        term_colors = false,
        eob_lines = true,
    },

    custom_highlights = {},
})

vim.cmd('colorscheme material')
