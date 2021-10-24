local present, py = pcall(require, 'dap-python')
if not present then
    return print('dap-python not found')
end
-- Python debugger
py.setup('~/.pyenv/versions/3.9.7/envs/debugpy/bin/python')
