local M = {}

function M.settings()
    local o = vim.o
    -- General settings
    vim.api.nvim_command('filetype plugin indent on')
    o.encoding = 'utf8'
    o.clipboard = 'unnamedplus'                     -- System clipboard
    o.mouse = 'a'                                   -- Enable mouse
    o.guifont ='JetBrainsMono Nerd Font Mono:h12'   -- GUI font
    o.number = true                                 -- Absolute line numbers
    o.relativenumber = true                         -- Relative line numbers
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
end

-- Python providers
function M.python()
    vim.g.python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'
    vim.g.python_host_prog = '~/.pyenv/versions/neovim2/bin/python2'
end

return M

