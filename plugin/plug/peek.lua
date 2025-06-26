if vim.fn.executable('deno') == 1 then
  local minideps = require('mini.deps')
  local add, now, later = minideps.add, minideps.now, minideps.later

  later(function()
    add({
      source = 'toppair/peek.nvim',
      hooks = {
        post_install = require('util').build_package({ 'deno', 'task', '--quiet', 'build:fast' }),
      },
    })
    require('peek').setup({
      auto_load = false,
      app = vim.fn.has('wsl') == 1 and 'firefox.exe' or 'app',
      theme = 'light',
    })
  end)

  now(function()
    local cmd = 'Peek'
    local commands = {
      open = function() require('peek').open() end,
      close = function() require('peek').close() end,
    }
    local group = vim.api.nvim_create_augroup('PeekCommand', {})
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      group = group,
      callback = function(au_data)
        vim.api.nvim_buf_create_user_command(au_data.buf, cmd, function(data)
          local prefix = require('util').parse(cmd, data.args)
          commands[prefix]()
        end, {
          nargs = 1,
          desc = 'Peek',
          complete = function(_, line) return require('util').complete(line, cmd, commands) end,
        })
      end,
    })
  end)
end
