local yank = vim.api.nvim_create_augroup('YankHighlight', {})
local term = vim.api.nvim_create_augroup('TermOptions', {})
local bufmod = vim.api.nvim_create_augroup('BufModifiable', {})
local trim = vim.api.nvim_create_augroup('TrimWhiteSpace', {})

--[[
local winaug = vim.api.nvim_create_augroup('HideCursorLine', {})
local excluded_filetypes = { 'neo-tree' }
]]

local autocmds = {
  {
    'TextYankPost',
    {
      callback = function()
        vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 350 })
      end,
      group = yank,
      desc = 'Setup yank highlight',
    },
  },
  {
    'TermOpen',
    {
      callback = function()
        vim.opt_local.scrolloff = 0
        vim.opt_local.sidescrolloff = 0
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
      group = term,
      desc = 'Set some options for terminal',
    },
  },
  {
    'BufRead',
    {
      callback = function()
        if vim.bo.readonly then
          vim.bo.modifiable = false
        end
      end,
      group = bufmod,
      desc = "Set 'noma' for 'readonly' files",
    },
  },
  --[[
  {
    'WinEnter',
    {
      callback = function()
        vim.opt_local.cursorlineopt = 'both'
      end,
      group = winaug,
      desc = "Enable 'cursorline' when leaving certain buffers",
    },
  },
  {
    'WinLeave',
    {
      callback = function()
        if not vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
          vim.opt_local.cursorlineopt = 'number'
        end
      end,
      group = winaug,
      desc = "Disable 'cursorline' in certain buffers",
    },
  },
  ]]
  {
    'BufWritePre',
    {
      callback = function(data)
        local buf = data.buf
        local enabled = require('util').trim_state(buf)
        if enabled then
          local n_lines = vim.api.nvim_buf_line_count(buf)
          local last_nonblank = vim.fn.prevnonblank(n_lines)
          if last_nonblank < n_lines then
            vim.api.nvim_buf_set_lines(buf, last_nonblank, n_lines, true, {})
          end

          local winid = vim.fn.bufwinid(buf)
          local current_win = vim.api.nvim_get_current_win()
          if vim.api.nvim_win_is_valid(winid) and winid == current_win then
            local curpos = vim.api.nvim_win_get_cursor(winid)
            vim.api.nvim_win_call(winid, function()
              vim.cmd([[keeppatterns %s/\s\+$//e]])
              vim.api.nvim_win_set_cursor(winid, curpos)
            end)
          end
        end
      end,
      group = trim,
      desc = 'Trim trailing whitespace',
    },
  },
}
for _, v in ipairs(autocmds) do
  vim.api.nvim_create_autocmd(unpack(v))
end
