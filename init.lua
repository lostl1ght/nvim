vim.g.color_theme = 'darker'

require('mars.bootstrap'):init()

local plugins = require('mars.plugin.list')
require('mars.plugin.loader'):load(plugins)

require('mars.core')
