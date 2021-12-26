local o = vim.o
-- General settings
vim.api.nvim_command('filetype plugin indent on')
o.clipboard = 'unnamedplus' -- System clipboard
o.mouse = 'a' -- Enable mouse
o.guifont = 'JetBrainsMono Nerd Font Mono:h8' -- GUI font
o.number = true -- Absolute line numbers
o.backup = false -- No auto backups
o.swapfile = false -- No swap
o.timeoutlen = 500 -- Wait for a mapped sequence

-- Text, tab and indent related
o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 4 -- One tab == four spaces
o.tabstop = 4 -- One tab == four spaces

-- Basic bindings
local map = vim.api.nvim_set_keymap
map('i', 'ii', '<esc>', { noremap = true }) -- Better ESC mapping
map('t', 'ii', '<c-\\><c-n>', { noremap = true }) -- Escape terminal the same way
map('t', '<esc>', '<c-\\><c-n>', { noremap = true })
map('', '<space>', '<leader>', { noremap = false }) -- Better Leader mapping
map('n', '<f1>', '<nop>', { noremap = false }) -- Disable F1
map('i', '<f1>', '<nop>', { noremap = false })

local disabled_built_ins = {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'gzip',
    'zip',
    'zipPlugin',
    'tar',
    'tarPlugin',
    'getscript',
    'getscriptPlugin',
    'vimball',
    'vimballPlugin',
    '2html_plugin',
    'logipat',
    'rrhelper',
    'spellfile_plugin',
    'matchit',
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
end

-- Keyboard layout
vim.cmd('set keymap=russian-jcukenwin')
vim.cmd('set iminsert=0')
vim.cmd('set imsearch=0')
map('i', '<c-l>', '<c-^>', { noremap = true })

-- Alternatives

-- vim.cmd(
--     'set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- )

-- vim.cmd([[
--     function! SetUsLayout()
--       silent !qdbus org.kde.keyboard /Layouts setLayout us > /dev/null
--     endfunction

--     autocmd InsertLeave * call SetUsLayout()
-- ]])

-- Eol and tab symbols
vim.cmd('set list listchars=tab:>\\ ,eol:↲')

-- Highlight yank
vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank({timeout = 350})')
