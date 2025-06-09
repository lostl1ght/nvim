local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'echasnovski/mini.files' })
  require('mini.files').setup({ windows = { preview = true } })

  vim.keymap.set('n', 'gft', function()
    local minifiles = require('mini.files')
    minifiles.open(minifiles.get_latest_path())
  end, {
    desc = 'Manager',
  })

  local group = vim.api.nvim_create_augroup('MiniFilesKeymaps', {})
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(data)
      local minifiles = require('mini.files')
      local buf_id = data.data.buf_id

      ---@param mode string|string[]
      ---@param l string
      ---@param r string|function
      ---@param opts table?
      local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = buf_id
        vim.keymap.set(mode, l, r, opts)
      end

      ---@param lhs string
      ---@param direction string
      local map_split = function(lhs, direction)
        local rhs = function()
          local entry = minifiles.get_fs_entry(buf_id)
          if entry == nil then return end
          if entry.fs_type == 'file' then
            local state = minifiles.get_explorer_state()
            if state == nil then return end
            local new_target_window
            local current_target_window = state.target_window
            if current_target_window == nil then return end
            vim.api.nvim_win_call(current_target_window, function()
              vim.cmd(direction .. ' split')
              new_target_window = vim.api.nvim_get_current_win()
            end)

            minifiles.set_target_window(new_target_window)
          end
          minifiles.go_in({})
        end

        local desc = 'Open ' .. direction .. ' split'
        map('n', lhs, rhs, { desc = desc })
      end

      local folders = function(local_opts)
        return function()
          local minipick = require('mini.pick')
          minipick.registry.folders(local_opts, {
            mappings = {
              stop = '',
              back = {
                char = '<esc>',
                func = function()
                  minipick.stop()
                  vim.defer_fn(function() minifiles.open(minifiles.get_latest_path(), true) end, 20)
                end,
              },
            },
          })
        end
      end

      map('n', 'gf', folders({ hidden = true }), { desc = 'Folders' })
      map('n', 'gF', folders({ hidden = true, no_ignore = true }), { desc = 'Ignored folders' })
      map('n', 'gh', function() minifiles.open(nil, false) end, { desc = 'Open cwd' })
      map('n', '<esc>', minifiles.close, { desc = 'Close' })
      map('n', '<c-c>', minifiles.close, { desc = 'Close' })
      map_split('gs', 'horizontal')
      map_split('gv', 'vertical')
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args)
      local win_id = args.data.win_id
      vim.api.nvim_win_set_config(win_id, { border = vim.g.border })
    end,
  })
end)
