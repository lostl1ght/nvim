--[[
  _       _ _     _
 (_)_ __ (_) |_  | |_   _  __ _
 | | '_ \| | __| | | | | |/ _` |
 | | | | | | |_ _| | |_| | (_| |
 |_|_| |_|_|\__(_)_|\__,_|\__,_|

       Neovim init file
--]]
local present, impatient = pcall(require, 'impatient')
if present then
    impatient.enable_profile()
end

present, _ = pcall(require, 'packer')
require('plugin')

if present then
    require('core')
    require('lang')
    require('config')
else
    require('packer').sync()
end
