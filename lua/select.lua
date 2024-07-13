local ns_id = vim.api.nvim_create_namespace('CustomUiSelect')

local H = {}

H.expand_callable = function(x, ...)
  if vim.is_callable(x) then return x(...) end
  return x
end
H.item_to_string = function(item)
  item = H.expand_callable(item)
  if type(item) == 'string' then return item end
  if type(item) == 'table' and type(item.text) == 'string' then return item.text end
  return vim.inspect(item, { newline = ' ', indent = '' })
end

H.set_buflines = function(buf_id, lines)
  pcall(vim.api.nvim_buf_set_lines, buf_id, 0, -1, false, lines)
end

H.is_valid_win = function(win_id)
  return type(win_id) == 'number' and vim.api.nvim_win_is_valid(win_id)
end
H.get_first_valid_normal_window = function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win_id).relative == '' then return win_id end
  end
end

---@class util.SelectOpts
---@field prompt string?
---@field format_item fun(item):string?
---@field kind string?
---@field preview_item fun(item):string[]?

---@param items any[]
---@param opts util.SelectOpts
---@param on_choice any
local ui_select = function(items, opts, on_choice)
  local itemx_ext = {}
  local format_item = opts.format_item or H.item_to_string
  for idx, item in ipairs(items) do
    table.insert(itemx_ext, {
      text = ('%d %s'):format(idx, format_item(item)),
      item = item,
      index = idx,
    })
  end

  local preview_item = vim.is_callable(opts.preview_item) and opts.preview_item
    or function(x) return vim.split(vim.inspect(x), '\n') end
  local preview = function(buf_id, item) H.set_buflines(buf_id, preview_item(item.item)) end

  local minipick = require('mini.pick')

  local was_aborted = true
  local choose = function(item)
    was_aborted = false
    if item == nil then return end
    local win_target = minipick.get_picker_state().windows.target
    if not H.is_valid_win(win_target) then win_target = H.get_first_valid_normal_window() end
    vim.api.nvim_win_call(win_target, function()
      on_choice(items[item.index], item.index)
      minipick.set_picker_target_window(vim.api.nvim_get_current_win())
    end)
  end

  local show = function(buf_id, show_items, query)
    vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
    minipick.default_show(buf_id, show_items, query, { show_icons = false })
    for idx, item in ipairs(show_items) do
      vim.api.nvim_buf_set_extmark(buf_id, ns_id, idx - 1, 0, {
        hl_group = 'DiagnosticWarn',
        end_col = select(2, string.find(item.text, '^%s*%d+:?%s')),
        priority = 10,
      })
    end
  end

  local pick_opts = {
    source = {
      items = itemx_ext,
      name = opts.prompt or opts.kind,
      preview = preview,
      choose = choose,
      show = show,
    },
    window = {
      config = function()
        local height = math.floor(vim.opt.lines:get() * 0.25)
        local width = math.floor(vim.opt.columns:get() * 0.4)
        return {
          height = height,
          width = width,
          anchor = 'NW',
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
          border = vim.g.border,
        }
      end,
    },
  }

  if minipick.start(pick_opts) == nil and was_aborted then on_choice(nil) end
end

return { ui_select = ui_select }
