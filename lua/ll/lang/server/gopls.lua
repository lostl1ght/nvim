local capabilities = require('ll.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return print('lspconfig not found')
end
-- Gopls
local util = require('lspconfig.util')
require('lspconfig').gopls.setup({
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod' },
    root_dir = function(fname)
        local root_files = {
            'go.mod',
        }
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
})
