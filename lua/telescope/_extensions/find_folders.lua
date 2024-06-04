local tmf = require('find_folders')
return require('telescope').register_extension({
  setup = tmf.setup,
  exports = {
    find_folders = tmf.find_folders,
  },
})
