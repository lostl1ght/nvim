-- C/C++ language server
local capabilities = require('lang.completion.capabilities')
local util = require('lspconfig.util')
require('lspconfig').ccls.setup{
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_dir = function(fname)
        local root_files = {
            'compile_commands.json',
            '.ccls',
            'compile_flags.txt',
        }
        return util.root_pattern(table.unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    init_options = {
        compilationDatabaseDirectory = '',
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { '-frounding-math'} ;
        },
        cache = {
            directory = '.ccls-cache';
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}
