local capabilities = require('ll.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return print('lspconfig not found')
end
-- Python language server
local util = require('lspconfig.util')
require('lspconfig').pyright.setup({
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_dir = function(fname)
        local root_files = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
        }
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
            },
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
})
