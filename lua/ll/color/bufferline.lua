local present, line = pcall(require, 'bufferline')
if not present then
    return print('bufferline not found')
end

vim.o.termguicolors = true
line.setup {
    options = {
        numbers =  function(opts)
            return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
        end,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = ' '
            for e, n in pairs(diagnostics_dict) do
                local sym = e == 'error' and '  ' or (e == 'warning' and '  ' or '  ' )
                s = s .. n .. sym
            end
            return s
        end,
    }
}

