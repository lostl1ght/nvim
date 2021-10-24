vim.g.color_theme = 'oceanic'

require('lostlight.bootstrap'):init()

local plugins = require('lostlight.plugin.list')
require('lostlight.plugin.loader'):load(plugins)

require('lostlight.core')
