local capabilities = require('lostlight.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return
end
-- Rust analyzer
local util = require('lspconfig.util')
require('lspconfig').rust_analyzer.setup{
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function (fname)
        local root_files = {
            'Cargo.toml',
            'rust-project.json'
        }
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    settings = {
      ['rust-analyzer'] = {
            assist = {
                importGranularity = 'module',
                importPrefix = 'by_self',
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
      },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}
