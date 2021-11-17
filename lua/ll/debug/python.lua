local present, py = pcall(require, 'dap-python')
if not present then
    return print('dap-python not found')
end
py.setup('~/.pyenv/versions/debugpy/bin/python')
