local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true}

-- Russian navigation
map('n', 'р', 'h', default_opts)
map('n', 'о', 'j', default_opts)
map('n', 'л', 'k', default_opts)
map('n', 'д', 'l', default_opts)

-- How to enter insert mode in russian
map('n', 'ш', 'i', default_opts)
map('n', 'Ш', 'I', default_opts)
map('n', 'ф', 'a', default_opts)
map('n', 'Ф', 'A', default_opts)
map('n', 'к', 'r', default_opts)
map('n', 'с', 'c', default_opts)
map('n', 'С', 'C', default_opts)
