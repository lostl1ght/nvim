local yank = vim.api.nvim_create_augroup('YankHighlight', {})
local term = vim.api.nvim_create_augroup('TermOptions', {})
local bufmod = vim.api.nvim_create_augroup('BufModifiable', {})

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
}
for _, v in ipairs(autocmds) do
  vim.api.nvim_create_autocmd(unpack(v))
end
