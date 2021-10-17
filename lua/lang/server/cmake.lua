-- Cmake language server
local capabilities = require('lang.completion.capabilities')
local util = require('lspconfig.util')
require('lspconfig').cmake.setup{
    cmd = { '/home/master/.pyenv/versions/cmake-ls/bin/cmake-language-server' },
    filetypes = { 'cmake' },
    init_options = {
    buildDirectory = 'build'
    },
    root_dir = function(fname)
        local root_files = {
            'compile_commands.json',
            'build',
        }
        return util.find_git_ancestor(fname) or util.root_pattern(unpack(root_files))(fname) or util.path.dirname(fname)
    end,
    capabilities = capabilities,
}
