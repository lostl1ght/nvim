local present, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not present then
    return
end

treesitter_configs.setup {
    ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'latex',
        'lua',
        'python',
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}
