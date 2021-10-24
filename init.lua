vim.g.color_theme = 'oceanic'

require('mars.bootstrap'):init()

local plugins = require('mars.plugin.list')
require('mars.plugin.loader'):load(plugins)

require('mars.core')
require('mars.lang')
require('mars.plugin.config')
require('mars.debugger')
require('mars.snippet')
