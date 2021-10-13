local M = {}
-- Latex language server
function M.setup()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    require'lspconfig'.texlab.setup{
        cmd = { "texlab" },
        filetypes = { "tex", "bib" },
        --root_dir = vim's starting directory
        settings = {
            texlab = {
                auxDirectory = ".",
                bibtexFormatter = "texlab",
                build = {
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    executable = "latexmk",
                    forwardSearchAfter = false,
                    onSave = false
                },
                chktex = {
                    onEdit = false,
                    onOpenAndSave = false
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                forwardSearch = {
                    args = {}
                },
                latexFormatter = "latexindent",
                latexindent = {
                    modifyLineBreaks = false
                }
            }
        },
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities,
    }
end

return M
