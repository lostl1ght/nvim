local g = vim.g
local fn = vim.fn

-- IPython setup
g.slime_target = 'tmux'
g.slime_python_ipython = 1
g.slime_default_config = { socket_name = fn.get(fn.split(vim.env.TMUX, ','), 0), target_pane = '{top-right}' }
g.slime_dont_ask_default = 1
