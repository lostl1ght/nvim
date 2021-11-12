require('ll.core.bootstrap'):init()
require('ll.core')

llvim.theme = 'nebulous'
llvim.style = 'midnight'

local plugins = require('ll.plugin.list')
require('ll.plugin.loader'):load(plugins)
