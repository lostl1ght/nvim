local M = {}
function M.load()
  local maps = {
    { ' ', '', mode = 'x' },
    { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit' },
    { '<leader>qQ', '<cmd>qa!<cr>', desc = 'Quit without saving' },
    -- +----------+
    -- + Terminal +
    -- +----------+
    { '<esc><esc>', '<c-\\><c-n>', mode = 't' },
    -- +--------+
    -- + Insert +
    -- +--------+
    { 'ii', '<esc>', mode = 'i' },
    { '<f1>', '', mode = 'i', remap = true },
    -- { '<c-h>', '<left>', mode = 'i', desc = 'Move cursor right' },
    -- { '<c-l>', '<right>', mode = 'i', desc = 'Move cursor left' },
    -- +-------+
    -- + Basic +
    -- +-------+
    { ' ', '' },
    { '<f1>', '', remap = true },
    { 'Q', 'q', desc = 'Macro' },
    { 'q', '', remap = true },
    {
      '<leader>th',
      function()
        ---@diagnostic disable-next-line
        vim.cmd('let v:hlsearch=' .. bit.bxor(vim.v.hlsearch, 1))
        vim.schedule(function()
          -- pcall(vim.api.nvim_cmd, { cmd = 'ScrollViewRefresh' }, {})
          vim.cmd({ cmd = 'redrawstatus' })
        end)
      end,
      desc = 'Highlight search',
    },
    {
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
    },
    {
      'j',
      'gj',
    },
    {
      'k',
      'gk',
    },
    -- +---------+
    -- + Buffers +
    -- +---------+
    {
      '<leader>`',
      function()
        pcall(vim.cmd.buffer, '#')
      end,
      desc = 'Switch to last',
    },
    --[[
    {
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
    },
    {
      '<leader>bD',
      function()
        vim.cmd.bdelete({ bang = true })
      end,
      desc = 'Delete without saving',
    },
    ]]
  }

  for _, map in ipairs(maps) do
    local opts = {}
    for key, val in pairs(map) do
      if type(key) ~= 'number' and key ~= 'mode' then
        opts[key] = val
      end
    end
    vim.keymap.set(map.mode or 'n', map[1], map[2], opts)
  end
end
return M
