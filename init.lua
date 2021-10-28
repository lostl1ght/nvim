require('ll.core.bootstrap'):init()
require('ll.core')

llvim.theme = 'material'
llvim.style = 'deep ocean'

local plugins = require('ll.plugin.list')
require('ll.plugin.loader'):load(plugins)

