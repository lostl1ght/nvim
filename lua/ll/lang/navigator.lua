local present, navigator = pcall(require, 'navigator')
if not present then
    return print('navigator not found')
end

local servers = {
    'angularls',
    'gopls',
    'tsserver',
    'flow',
    'bashls',
    'dockerls',
    'julials',
    'pylsp',
    'pyright',
    'jedi_language_server',
    'jdtls',
    'sumneko_lua',
    'vimls',
    'html',
    'jsonls',
    'solargraph',
    'cssls',
    'yamlls',
    'clangd',
    'ccls',
    'sqls',
    'denols',
    'graphql',
    'dartls',
    'dotls',
    'kotlin_language_server',
    'nimls',
    'intelephense',
    'vuels',
    'phpactor',
    'omnisharp',
    'r_language_server',
    'rust_analyzer',
    'terraformls',
    'svelte',
    'texlab',
    'clojure_lsp',
}

navigator.setup({
    default_mapping = false,
    lsp = {
        disable_lsp = servers,
        format_on_save = false,
        code_action = {
            virtual_text = false,
        },
        code_lens_action = {
            virtual_text = false,
        },
    },
    icons = {
        icons = true,
        code_lens_action_icon = '',
        code_action_icon = '',
        diagnostic_virtual_text = '',
        diagnostic_err = '',
        diagnostic_warn = '',
        diagnostic_hint = '',
        value_changed = '',
        value_definition = 'ﲏ',
    },
})
