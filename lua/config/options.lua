local cache_dir = vim.fn.stdpath('cache')
local o = vim.o

o.background = 'dark'
o.backup = false
o.backupdir = cache_dir .. '/backup'
o.breakindent = true
o.breakindentopt = 'shift:2,min:20'
o.cmdheight = 1
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.clipboard = 'unnamedplus'
o.directory = cache_dir .. '/swap'
o.equalalways = false
o.expandtab = true
o.fillchars = 'diff:╱'
o.foldcolumn = 'auto'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldtext = "v:lua.require'foldtext'.get()"
o.guifont = 'JetBrainsMono Nerd Font Mono:h09'
o.history = 2000
o.ignorecase = true
o.keymap = 'russian-jcukenwin'
o.iminsert = 0
o.imsearch = -1
o.laststatus = 2
o.list = true
o.listchars = 'tab:╎ ,nbsp:+,trail:·,extends:→,precedes:←'
o.mouse = 'a'
o.mousemodel = 'extend'
o.number = true
o.pumblend = 0
o.pumheight = 10
o.redrawtime = 1500
o.relativenumber = true
o.scrolloff = 3
o.sessionoptions = 'buffers,curdir,tabpages,winsize'
o.shada = "!,'300,<50,@100,s10,h"
o.shiftround = true
o.shiftwidth = 4
o.showtabline = 1
o.sidescrolloff = 5
o.shortmess = 'ltToOCFIc'
o.showmode = false
o.splitkeep = 'cursor'
o.shiftround = true
o.signcolumn = 'yes'
o.statuscolumn = "%!v:lua.require'statuscolumn'.get()"
o.smartcase = true
o.smartindent = true
-- o.splitbelow = true
-- o.splitright = true
o.swapfile = false
o.tabstop = 4
o.termguicolors = true
o.timeoutlen = 500
o.title = true
o.titlestring = "%{%v:lua.require'titlestring'.get()%}"
o.undodir = cache_dir .. '/undo'
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.viewdir = cache_dir .. '/view'
o.virtualedit = 'block'
o.whichwrap = '<,>,[,]'
o.wildmode = 'longest:full,full'
o.winminwidth = 5
o.writebackup = false

local g = vim.g
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.markdown_recommended_style = 0
g.tex_flavor = 'latex'

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FormatOptions', {}),
  callback = function() vim.cmd('setlocal formatoptions-=cro') end,
})

--[[
-- NOTE: maybe uncomment on 0.11
pcall(vim.keymap.del, 'n', 'grr')
pcall(vim.keymap.del, { 'n', 'x' }, 'gra')
pcall(vim.keymap.del, 'n', 'grn')
]]
