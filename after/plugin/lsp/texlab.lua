local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local opts = {
    key = '<leader>m',
    name = '<localleader>',
    buf = data.buf,
  }

  local texlab = {
    {
      '<localleader>b',
      function()
        vim.cmd({ cmd = 'TexlabBuild' })
      end,
      desc = 'Build',
      buffer = data.buf,
    },
    {
      '<localleader>f',
      function()
        vim.cmd({ cmd = 'TexlabForward' })
      end,
      desc = 'Forward',
      buffer = data.buf,
    },
  }
  local util = require('util')
  if client.name == 'texlab' then
    for _, map in ipairs(texlab) do
      util.keymap_set(map)
    end
    util.set_which_key(opts)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspTexlab', {}),
})
