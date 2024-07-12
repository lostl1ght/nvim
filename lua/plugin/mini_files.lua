local MiniDeps = require('mini.deps')
local add, now = MiniDeps.add, MiniDeps.now
now(function()
  add({ source = 'echasnovski/mini.files' })
  require('mini.files').setup({ windows = { preview = true } })

  vim.keymap.set('n', 'gft', function()
    local MiniFiles = MiniFiles or require('mini.files')
    MiniFiles.open(MiniFiles.get_latest_path())
  end, {
    desc = 'Manager',
  })

  local function map_split(buf_id, lhs, direction)
    local function rhs()
      local MiniFiles = MiniFiles or require('mini.files')
      local entry = MiniFiles.get_fs_entry(buf_id)
      if entry == nil then return end
      if entry.fs_type == 'file' then
        local new_target_window
        local current_target_window = MiniFiles.get_target_window()
        if current_target_window == nil then return end
        vim.api.nvim_win_call(current_target_window, function()
          vim.cmd(direction .. ' split')
          new_target_window = vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target_window)
      end
      MiniFiles.go_in({})
    end

    local desc = 'Open ' .. direction .. ' split'
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
  end

  local group = vim.api.nvim_create_augroup('MiniFilesKeymaps', {})
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(data)
      local MiniFiles = MiniFiles or require('mini.files')
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
      map('n', 'gt', function() vim.cmd('Pick folders hidden=true') end, { desc = 'Folders' })
      map(
        'n',
        'gT',
        function() vim.cmd('Pick folders hidden=true no_ignore=true') end,
        { desc = 'Ignored folders' }
      )
      map('n', 'gh', function() MiniFiles.open(nil, false) end, { desc = 'Open cwd' })
      map('n', '<esc>', MiniFiles.close, { desc = 'Close' })
      map('n', '<c-c>', MiniFiles.close, { desc = 'Close' })
      map_split(buf_id, 'gs', 'horizontal')
      map_split(buf_id, 'gv', 'vertical')
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
