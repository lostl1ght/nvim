local present, nebulous = pcall(require, 'nebulous')
if not present then
    return print('nebulous not found')
end

nebulous.setup {
    variant = llvim.style,
    disable = {
        background = false,
        endOfBuffer = false,
    },
    italic = {
        comments   = true,
        keywords   = false,
        functions  = false,
        variables  = false,
    },
}
