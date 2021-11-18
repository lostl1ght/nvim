require('ll.core').init()

-- nebulous or material
llvim.theme = 'nebulous'

-- nebulous: fullmoon, midnight, twilight, night
-- material: deep ocean, oceanic, palenight, lighter, darker
llvim.style = 'midnight'

require('ll.core').load()

local plugins = require('ll.plugin.list')
require('ll.plugin.loader'):load(plugins)
