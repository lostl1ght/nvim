local present, navigator = pcall(require, 'navigator')
if not present then
    return print('navigator not found')
end

navigator.setup({
    default_mapping = false,
    lsp = {
        disable_lsp = 'all',
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
        treesitter_defult = '',
        match_kinds = {
            method = 'ƒ ',
            ['function'] = ' ',
            parameter = '',
            type = '',
            associated = '',
            namespace = '',
            field = '',
        },
    },
})
