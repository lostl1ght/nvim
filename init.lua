vim.g.color_theme = 'oceanic'

require('ll.core.bootstrap'):init()

local plugins = require('ll.plugin.list')
require('ll.plugin.loader'):load(plugins)

require('ll.core')
