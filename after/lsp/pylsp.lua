-- cd ~/.local/share/nvim/mason/packages/python-lsp-server
-- source venv/bin/activate
-- pip install python-lsp-ruff
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
