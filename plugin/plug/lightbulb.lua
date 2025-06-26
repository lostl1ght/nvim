local minideps = require('mini.deps')
local later = minideps.later

later(function() require('lightbulb').setup_au() end)
