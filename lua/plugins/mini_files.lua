---@type LazyPluginSpec
return {
  'echasnovski/mini.files',
  lazy = false,
  keys = {
    {
      '<leader>ft',
      function()
        local mini_files = require('mini.files')
        mini_files.open(mini_files.get_latest_path())
      end,
      desc = 'Manager',
    },
  },

  config = function()
    local mini_files = require('mini.files')
    mini_files.setup({
      windows = {
        preview = true,
      },
    })

    local function map_split(buf_id, lhs, direction)
      local function rhs()
        local entry = mini_files.get_fs_entry(buf_id)
        if entry == nil then
          return
        end
        if entry.fs_type == 'file' then
          local new_target_window
          local current_target_window = mini_files.get_target_window()
          if current_target_window == nil then
            return
          end
          vim.api.nvim_win_call(current_target_window, function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          mini_files.set_target_window(new_target_window)
        end
        mini_files.go_in({})
      end

      local desc = 'Open ' .. direction .. ' split'
      vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
    end

    local group = vim.api.nvim_create_augroup('MiniFilesKeymaps', {})
    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', 'gf', function()
          vim.cmd('Telescope find_folders')
        end, { buffer = buf_id, desc = 'Folders' })
        vim.keymap.set('n', 'gF', function()
          vim.cmd('Telescope find_folders no_ignore=true')
        end, { buffer = buf_id, desc = 'Ignored folders' })
        --[[
      vim.keymap.set('n', 'gf', function()
        vim.cmd('Pick folders hidden=true')
      end, { buffer = buf_id, desc = 'Folders' })
      vim.keymap.set('n', 'gF', function()
        vim.cmd('Pick folders hidden=true no_ignore=true')
      end, { buffer = buf_id, desc = 'Ignored folders' })
      ]]
        vim.keymap.set('n', 'gh', function()
          mini_files.open(nil, false)
        end, { buffer = buf_id, desc = 'Open cwd' })
        vim.keymap.set('n', '<esc>', mini_files.close, { buffer = buf_id, desc = 'Close' })
        map_split(buf_id, 'gs', 'horizontal')
        map_split(buf_id, 'gv', 'vertical')
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesWindowOpen',
      callback = function(args)
        local win_id = args.data.win_id
        vim.api.nvim_win_set_config(win_id, { border = 'rounded' })
      end,
    })
  end,
}
