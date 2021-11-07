local capabilities = require('ll.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return print('lspconfig not found')
end

require('lspconfig').ltex.setup({
    cmd = { 'ltex-ls' },
    filetypes = { 'tex', 'bib', 'markdown' },
    settings = {
        ltex = {
            additionalRules = {
                enablePickyRules = true,
                motherTongue = 'en',
            },
            checkFrequency = 'edit',
            diagnosticSeverity = 'information',
            dictionary = {},
            disabledRules = {},
            enabled = { 'latex', 'tex', 'bib', 'markdown' },
            hiddenFalsePositives = {},
            language = 'en',
            setenceCacheSize = 2000,
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
})
