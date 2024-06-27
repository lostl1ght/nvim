local function callback(data)
  local client = vim.lsp.get_client_by_id(data.data.client_id)
  if not client then
    return
  end

  local util = require('util')
  local set = util.keymap_set
  local mc = util.set_mini_clue

  if client.name == 'texlab' then
    set({
      '<localleader>b',
      function()
        vim.cmd({ cmd = 'TexlabBuild' })
      end,
      desc = 'Build',
      buffer = data.buf,
    })
    set({
      '<localleader>f',
      function()
        vim.cmd({ cmd = 'TexlabForward' })
      end,
      desc = 'Forward',
      buffer = data.buf,
    })

    mc({
      key = '<leader>m',
      name = '<localleader>',
      buf = data.buf,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = callback,
  group = vim.api.nvim_create_augroup('LspTexlab', {}),
})
