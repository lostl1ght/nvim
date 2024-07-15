local cache_dir = vim.fn.stdpath('cache')

vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.backupdir = cache_dir .. '/backup'
vim.opt.breakindent = true
vim.opt.breakindentopt = { shift = 2, min = 20 }
vim.opt.cmdheight = 1
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.cursorline = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.directory = cache_dir .. '/swap'
vim.opt.equalalways = false
vim.opt.expandtab = true
vim.opt.fillchars = { diff = '╱', fold = ' ' }
vim.opt.foldcolumn = 'auto'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldtext = "v:lua.require'foldtext'.get()"
vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h09'
vim.opt.history = 2000
vim.opt.ignorecase = true
vim.opt.keymap = 'russian-jcukenwin'
vim.opt.iminsert = 0
vim.opt.imsearch = -1
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = '╎ ', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'
vim.opt.number = true
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.redrawtime = 1500
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.showtabline = 2
vim.opt.sidescrolloff = 5
vim.opt.shortmess:append({ I = true, c = true, C = true })
vim.opt.showmode = false
vim.opt.splitkeep = 'screen'
vim.opt.shiftround = true
vim.opt.signcolumn = 'yes'
vim.opt.statuscolumn = "%!v:lua.require'statuscolumn'.get()"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.title = false
vim.opt.titlestring = ''
vim.opt.undodir = cache_dir .. '/undo'
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.viewdir = cache_dir .. '/view'
vim.opt.virtualedit = { 'block' }
vim.opt.whichwrap = '<,>,[,]'
vim.opt.wildmode = 'longest:full,full'
vim.opt.winminwidth = 5
vim.opt.writebackup = false

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ' m'
vim.g.markdown_recommended_style = 0
vim.g.tex_flavor = 'latex'

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FormatOptions', {}),
  pattern = '*',
  callback = function() vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' }) end,
})

--[[
-- NOTE: maybe uncomment on 0.11
pcall(vim.keymap.del, 'n', 'grr')
pcall(vim.keymap.del, { 'n', 'x' }, 'gra')
pcall(vim.keymap.del, 'n', 'grn')
]]
