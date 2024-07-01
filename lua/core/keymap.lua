local M = {}
function M.load()
  local set = require('util').keymap_set
  set({ '<esc><esc>', '<c-\\><c-n>', mode = 't' })
  set({ 'ii', '<esc>', mode = 'i' })
  set({ '<f1>', '', mode = '', remap = true })
  -- set({ 'Q', 'q', desc = 'Macro' })
  -- set({ 'q', '', remap = true })
  set({ '<leader>qq', '<cmd>qa<cr>', desc = 'Quit' })
  set({ '<leader>qQ', '<cmd>qa!<cr>', desc = 'Quit without saving' })
  set({
    '<leader>th',
    function()
      vim.cmd('let v:hlsearch=' .. bit.bxor(vim.v.hlsearch, 1))
      vim.schedule(function()
        -- pcall(vim.api.nvim_cmd, { cmd = 'ScrollViewRefresh' }, {})
        vim.cmd({ cmd = 'redrawstatus' })
      end)
    end,
    desc = 'Highlight search',
  })
  set({
    '<leader>fs',
    function()
      local ok, result = pcall(vim.api.nvim_cmd, { cmd = 'write', mods = { silent = true } }, {})
      if not ok then
        vim.notify(
          string.gsub(result, 'Vim:%w*%d*: ', ''),
          vim.log.levels.ERROR,
          { title = 'Write' }
        )
      end
    end,
    desc = 'Write',
  })
  set({ 'j', 'gj' })
  set({ 'k', 'gk' })
  set({
    '<leader>`',
    function()
      pcall(vim.cmd.buffer, '#')
    end,
    desc = 'Switch to last',
  })
  --[[
  set({
    '<leader>bd',
    function()
      if vim.o.modified then
        vim.notify('Save before closing')
      elseif vim.o.buftype == 'terminal' then
        vim.notify('Kill the terminal')
      else
        vim.cmd.bdelete()
      end
    end,
    desc = 'Delete',
  })
  set({
    '<leader>bD',
    function()
      vim.cmd.bdelete({ bang = true })
    end,
    desc = 'Delete without saving',
  })
  ]]
end
return M
