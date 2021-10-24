local cmd = vim.cmd

-- Syntax highlighting
cmd 'au BufRead,BufNewFile *.ASM set ft=masm'
cmd 'au BufRead,BufNewFile *.asm set ft=masm'
cmd 'au BufRead,BufNewFile *.s set ft=gas'

-- Tree-sitter setup
require('nvim-treesitter.configs').setup {
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
