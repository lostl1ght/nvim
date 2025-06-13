vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('TinyMistPinCmd', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= 'tinymist' then return end
    local name = 'Tinymist'
    local commands = {
      pin = function()
        client:exec_cmd({
          title = 'unpin',
          command = 'tinymist.pinMain',
          arguments = { vim.api.nvim_buf_get_name(0) },
        }, { bufnr = vim.fn.bufnr() })
      end,
      unpin = function()
        client:exec_cmd({
          title = 'unpin',
          command = 'tinymist.pinMain',
          arguments = { vim.v.null },
        }, { bufnr = vim.fn.bufnr() })
      end,
    }
    vim.api.nvim_buf_create_user_command(ev.buf, name, function(data)
      local prefix = require('util').parse(name, data.args)
      commands[prefix]()
    end, {
      nargs = 1,
      desc = name,
      complete = function(_, line) return require('util').complete(line, name, commands) end,
    })
  end,
})
return {
  on_attach = function(_, _) end,
}
