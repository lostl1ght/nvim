local t_present, tele = pcall(require, 'telescope')
local s_present, sess = pcall(require, 'session_manager')
if not t_present or not s_present then
    return print('telescope or session_manager not found')
end
-- Session manager
sess.setup({
    sessions_dir = vim.fn.stdpath('data') .. '/sessions',     -- Session directory
    path_replacer = '__',                                     -- Path separator
    colon_replacer = '++',                                    -- Colon symbol
    autoload_last_session = false,                            -- Load on startup
    autosave_last_session = true,                             -- Save on exit
    autosave_ignore_paths = { '~' },                          -- Folders to ignore when autosaving
    autosave_ignore_not_normal = true,
})
tele.load_extension('sessions')
