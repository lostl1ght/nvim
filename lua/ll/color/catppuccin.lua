local present, catppuccin = pcall(require, 'catppuccin')
if not present then
    return print('catppuccin not found')
end
catppuccin.setup({
    transparent_background = false,
    term_colors = false,
    styles = {
        comments = 'italic',
        functions = 'italic',
        keywords = 'italic',
        strings = 'NONE',
        variables = 'NONE',
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = 'italic',
                hints = 'italic',
                warnings = 'italic',
                information = 'italic',
            },
            underlines = {
                errors = 'underline',
                hints = 'underline',
                warnings = 'underline',
                information = 'underline',
            },
        },
        lsp_trouble = true,
        lsp_saga = false,
        gitgutter = true,
        gitsigns = true,
        telescope = true,
        nvimtree = {
            enabled = true,
            show_root = false,
        },
        which_key = true,
        indent_blankline = {
            enabled = false,
            colored_indent_levels = false,
        },
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = false,
        markdown = true,
        lightspeed = false,
        ts_rainbow = false,
        hop = false,
    },
})
vim.cmd[[colorscheme catppuccin]]
