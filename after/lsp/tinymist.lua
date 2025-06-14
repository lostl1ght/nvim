return {
  on_attach = function(client, bufnr)
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
    vim.api.nvim_buf_create_user_command(bufnr, name, function(data)
      local prefix = require('util').parse(name, data.args)
      commands[prefix]()
    end, {
      nargs = 1,
      desc = name,
      complete = function(_, line) return require('util').complete(line, name, commands) end,
    })
  end,
}
