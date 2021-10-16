-- Latex language server
local capabilities = require('lang.completion.capabilities')
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
