local M = {}
-- C/C++ language server
function M.setup()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    local util = require('lspconfig/util')
    require'lspconfig'.clangd.setup{
    cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = function(fname)
            local root_files = {
                'compile_commands.json',
                'compile_flags.txt',
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities,
    }
end

return M
