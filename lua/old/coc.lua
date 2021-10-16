-- Installation directory
vim.g.coc_data_home = vim.fn.stdpath('data') .. '/coc'

-- List of extensions
vim.g.coc_global_extensions = {
    'coc-clangd',
    'coc-db',
    'coc-json',
    'coc-pyright',
    'coc-sumneko-lua',
    'coc-texlab',
}

-- CoC bindings
require('which-key').register({
    ['<leader>'] = {
        c = {
            name = '+code',
            n = { '<plug>(coc-rename)', 'Rename' },
            d = { '<plug>(coc-definition)', 'Definition' },
            i = { '<plug>(coc-implementation)', 'Implementation' },
            r = { '<plug>(coc-references)', 'References' },
            y = { '<plug>(coc-type-definition)', 'Type definition' },
        },
    },
    ['[e'] = { '<plug>(coc-diagnostic-prev)', 'previous code error' },
    [']e'] = { '<plug>(coc-diagnostic-next)', 'Next code error' },
},
{ mode = 'n' })

require('which-key').register({
    ['<leader>'] = {
        r = {
            name = '+format',
            f = { '<plug>(coc-format-selected)', 'Format selected' },
        }
    }
},
{ mode = 'x' })

local map = vim.api.nvim_set_keymap

-- Termcodes
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Smart tab setup
local function check_back_space()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
end

function Smart_tab()
    return vim.fn.pumvisible() == 1 and t('<c-n>') or check_back_space() and t('<tab>') or vim.fn['coc#refresh']()
end

function Smart_stab()
    return vim.fn.pumvisible() == 1 and t('<c-p>') or t('<c-h')
end

map('i', '<tab>', 'v:lua.Smart_tab()', {silent = true, expr = true, noremap = true})
map('i', '<s-tab>', 'v:lua.Smart_stab()', {silent = true, expr = true, noremap = true})

-- Select on return
function Cr_select()
    local tldr = t('<c-g>') .. 'u' .. t('<cr>') .. t('<c-r>') .. '=coc#on_enter()' .. t('<cr>')
    return vim.fn.pumvisible() == 1 and  vim.fn['coc#_select_confirm']() or tldr
end

map('i', '<cr>', 'v:lua.Cr_select()', {silent = true, expr = true, noremap = true})

-- Show documentation
function Show_documentation()
   local filetype = vim.bo.filetype

   if filetype == 'vim'  or filetype == 'help' then
        vim.api.nvim_command('h ' .. filetype)
   elseif vim.fn['coc#rpc#ready']() then
     vim.fn.CocActionAsync('doHover')
   end
end

map('n', 'K', '<cmd>lua Show_documentation()<cr>', {noremap = true, silent = true})

