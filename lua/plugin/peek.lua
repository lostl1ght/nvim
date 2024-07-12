if vim.fn.executable('deno') == 1 then
  local MiniDeps = require('mini.deps')
  local add, later = MiniDeps.add, MiniDeps.later
  later(function()
    add({
      source = 'toppair/peek.nvim',
      hooks = {
        post_install = function(spec)
          later(function()
            vim.system(
              {
                'deno',
                'task',
                '--cwd',
                spec.path,
                '--quiet',
                'build:fast',
              },
              { text = true },
              function(obj)
                vim.notify(
                  'Finished building `peek.nvim`; code ' .. obj.code,
                  obj.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
                )
              end
            )
          end)
        end,
      },
    })
    require('peek').setup({
      auto_load = false,
      app = vim.fn.has('wsl') == 1 and 'firefox.exe' or 'app',
      theme = 'light',
    })

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