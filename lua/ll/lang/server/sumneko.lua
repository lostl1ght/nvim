local capabilities = require('ll.lang.completion.capabilities')
if not pcall(require, 'lspconfig') or not capabilities then
    return print('lspconfig not found')
end
-- Lua language server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
    cmd = {'lua-language-server'};
    settings = {
        Lua = {
            runtime = {
                -- Lua version
                version = 'LuaJIT',
                -- Lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Predefined globals
                globals = {'vim', 'use'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Disable telemetry
            telemetry = {
                enable = false,
            },
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}
