local present, sm = pcall(require, 'session_manager')
if not present then
    return print('session_manager not found')
end
sm.setup({
    sessions_dir = vim.fn.stdpath('data') .. '/sessions',
    path_replacer = '__',
    colon_replacer = '++',
    autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
    autosave_last_session = true,
    autosave_ignore_not_normal = true,
})
