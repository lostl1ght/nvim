local M = {}

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')

local mini_files = require('mini.files')

local config = {
  borderchars = {
    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
  },
  layout_config = {
    height = 9,
    width = 78,
    anchor = 'NW',
  },
  layout_strategy = 'center',
  results_title = false,
  sorting_strategy = 'ascending',
  hidden = false,
  no_ignore = false,
  icon = '',
  mappings = {
    i = {
      ['<c-c>'] = 'go_back',
    },
    n = {
      ['<esc>'] = 'go_back',
      ['q'] = 'go_back',
    },
  },
}

local A = {}

function A.make_go_back(prompt_bufnr, opts)
  return function()
    actions.close(prompt_bufnr)
    mini_files.open(mini_files.get_latest_path(), true, opts)
  end
end

local function notify_error(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = 'find_folders' })
end

---@type fun(entry:table):string,table
local make_display

---Fuzzy search through folders and open in MiniFiles
---@param opts table?
function M.find_folders(opts)
  opts = vim.tbl_deep_extend('keep', opts or {}, config)

  local fd
  if vim.fn.executable('fd') == 1 then
    fd = 'fd'
  elseif vim.fn.executable('fdfind') == 1 then
    fd = 'fdfind'
  else
    notify_error('fd must be installed')
    return
  end

  local cmd = { fd, '--type', 'd', '--color', 'never' }
  if opts.hidden then
    table.insert(cmd, '--hidden')
  end
  if opts.no_ignore then
    table.insert(cmd, '--no-ignore')
  end

  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    notify_error(('fd returned code %d'):format(obj.code))
    return
  end

  local dirs = vim.split(obj.stdout, '\n', { trimempty = true })

  mini_files.close()
  pickers
    .new(opts, {
      prompt_title = 'Find folders',
      finder = finders.new_table({
        results = dirs,
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry,
            icon = config.icon,
            hl = 'Directory',
          }
        end,
      }),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          mini_files.open(selection.value, false, opts)
        end)

        for mode, maps in pairs(opts.mappings) do
          for key, act in pairs(maps) do
            if type(act) == 'string' then
              map(mode, key, A['make_' .. act](prompt_bufnr, opts))
            else
              map(mode, key, act)
            end
          end
        end

        return true
      end,
    })
    :find()
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts)
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = vim.fn.strwidth(config.icon) },
      { remaining = true },
    },
  })
  make_display = function(entry)
    return displayer({
      { entry.icon, entry.hl },
      { entry.value, entry.hl },
    })
  end
end

return M
--[[
local data = vim
  .iter(vim.iter.filter(function(_, type)
    if type == 'directory' then
      return true
    end
    return false
  end, vim.fs.dir(vim.uv.cwd(), { depth = math.huge })))
  :map(function(item)
    return item .. '/'
  end)
  :totable()

vim.print(data)
--]]
