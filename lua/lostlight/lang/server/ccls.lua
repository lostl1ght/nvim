local capabilities = require('lostlight.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return
end
-- C/C++ language server
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
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    init_options = {
        compilationDatabaseDirectory = '',
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = {'-frounding-math',}
        },
        cache = {
            directory = '.ccls-cache',
        },
        client = {
            snippetSupport = false,
        },
        completion = {
            placeholder = false,
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}
