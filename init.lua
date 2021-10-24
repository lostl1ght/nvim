require('mars.bootstrap'):init()

local plugins = require('mars.plugin.list')
require('mars.plugin.loader'):load(plugins)

require('mars.core')
require('mars.color')
require('mars.lang')
require('mars.plugin.config')
require('mars.debugger')
require('mars.snippet')