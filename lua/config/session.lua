-- Session manager
require('session_manager').setup({
sessions_dir = vim.fn.stdpath('data') .. '/sessions',     -- Session directory
path_replacer = '__',                                     -- Path separator
colon_replacer = '++',                                    -- Colon symbol
autoload_last_session = false,                            -- Load on startup
autosave_last_session = true,                             -- Save on exit
autosave_ignore_paths = { '~' },                          -- Folders to ignore when autosaving
})
require('telescope').load_extension('sessions')
