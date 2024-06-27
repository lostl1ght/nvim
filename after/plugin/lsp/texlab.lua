local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local opts = {
    key = '<leader>m',
    name = '<localleader>',
  }

  local texlab = {
    {
      '<localleader>b',
      function()
        vim.cmd({ cmd = 'TexlabBuild' })
      end,
      desc = 'Build',
    },
    {
      '<localleader>f',
      function()
        vim.cmd({ cmd = 'TexlabForward' })
      end,
      desc = 'Forward',
    },
  }
  local util = require('util')
  if client.name == 'texlab' then
    for _, map in ipairs(texlab) do
      util.keymap_set(map, data.buf, opts)
    end
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspTexlab', {}),
})
