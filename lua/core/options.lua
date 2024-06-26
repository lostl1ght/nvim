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
vim.opt.fillchars = { diff = '╱' }
vim.opt.foldlevel = 99
-- vim.opt.guifont = 'JetBrainsMono NFM:h9'
vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h9'
vim.opt.history = 2000
vim.opt.ignorecase = false
vim.opt.laststatus = 3
vim.opt.list = true
-- ├─
-- »·
vim.opt.listchars = { tab = '├ ', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'
vim.opt.number = true
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.redrawtime = 1500
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.showtabline = 2
vim.opt.sidescrolloff = 5
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false
vim.opt.splitkeep = 'screen'
vim.opt.shiftround = true
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.title = true
vim.opt.titlestring = [[%f %m]]
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
vim.g.trim_trailing_whitespace = true

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FormatOptions', {}),
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

--[[
-- Call to powershell.exe makes pasting very slow
-- and spikes CPU usage
-- Ensure powershell.exe and clip.exe are in PATH (symlinked)!
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+']= 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
]]
