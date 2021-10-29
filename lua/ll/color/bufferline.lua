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
    }
}

