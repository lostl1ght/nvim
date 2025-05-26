-- cd ~/.local/share/nvim/mason/packages/python-lsp-server
-- source venv/bin/activate
-- pip install pyls-isort pylsp-mypy pylsp-rope python-lsp-ruff
--[[
return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = {
          enabled = false,
        },
      },
    },
  },
}
]]
