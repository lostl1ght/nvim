local o = vim.o
-- General settings
vim.api.nvim_command('filetype plugin indent on')
o.clipboard = 'unnamedplus'                     -- System clipboard
o.mouse = 'a'                                   -- Enable mouse
o.guifont ='JetBrainsMono Nerd Font Mono:h12'   -- GUI font
o.number = true                                 -- Absolute line numbers
o.backup = false                                -- No auto backups
o.swapfile = false                              -- No swap
o.timeoutlen = 500                              -- Wait for a mapped sequence

-- Text, tab and indent related
o.expandtab = true                              -- Use spaces instead of tabs
o.shiftwidth = 4                                -- One tab == four spaces
o.tabstop = 4                                   -- One tab == four spaces

-- Basic bindings
local map = vim.api.nvim_set_keymap
map('i', 'ii', '<esc>', {noremap = true})           -- Better ESC mapping
map('t', 'ii', '<c-\\><c-n>', {noremap = true})     -- Escape terminal the same way
map('t', '<esc>', '<c-\\><c-n>', {noremap = true})
map('', '<space>', '<leader>', {noremap = false})   -- Better Leader mapping
map('n', '<f1>', '<nop>', {noremap = false})         -- Disable F1
map('i', '<f1>', '<nop>', {noremap = false})

vim.g.tex_flavor = 'latex'

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
    'matchit'
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
end
