require('ll.core').init()
require('ll.core').load()
local plugins = require('ll.plugin.list')
require('ll.plugin.loader'):load(plugins)
