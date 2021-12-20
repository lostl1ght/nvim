if not pcall(require, 'lspconfig') then
    return print('lspconfig not found')
end
local capabilities = require('ll.lang.completion.capabilities')
local util = require('lspconfig.util')
require('lspconfig').texlab.setup({
    cmd = { 'texlab' },
    filetypes = { 'tex', 'bib' },
    root_dir = function(fname)
        return util.root_pattern('.latexmkrc')(fname) or util.path.dirname(fname)
    end,
    settings = {
        texlab = {
            auxDirectory = '.',
            bibtexFormatter = 'texlab',
            build = {
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                executable = 'latexmk',
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                args = {},
            },
            latexFormatter = 'latexindent',
            latexindent = {
                modifyLineBreaks = false,
            },
        },
    },
    single_file_support = true,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
})
