local present, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not present then
    return print('treesitter not found')
end

treesitter_configs.setup({
    ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'latex',
        'lua',
        'python',
        'rust',
        'toml',
        'yaml',
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
-- vim.api.nvim_command('set foldmethod=expr')
-- vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
-- vim.api.nvim_command('set nofoldenable')
