local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.pick', depends = { 'echasnovski/mini.icons' } })
  vim.ui.select = require('select').ui_select

  local set = vim.keymap.set
  set('n', 'gff', '<cmd>Pick files<cr>', { desc = 'Files' })
  set('n', 'gfg', '<cmd>Pick grep<cr>', { desc = 'Grep' })
  set('n', 'gfl', '<cmd>Pick grep_live<cr>', { desc = 'Grep live' })
  set('n', 'gb', function()
    local minipick = require('mini.pick')
    local icons = setmetatable({
      [1] = {
        none = { ascii = '0 ', glyph = '󰞋 ' },
      },
    }, {
      __index = function(self, key) return self[1][key][require('mini.icons').config.style] end,
    })
    minipick.builtin.buffers({}, {
      source = {
        show = function(buf_id, items, query)
          vim.tbl_map(function(i) i.text = vim.fn.fnamemodify(i.text, ':~:.') end, items)
          minipick.default_show(buf_id, items, query, {
            show_icons = true,
            icons = { none = icons.none },
          })
        end,
        match = function(stritems, inds, query)
          stritems = vim.tbl_map(function(str) return vim.fn.fnamemodify(str, ':~:.') end, stritems)
          minipick.default_match(stritems, inds, query)
        end,
      },
      mappings = {
        delete = {
          char = '<c-d>',
          func = function()
            local matches = minipick.get_picker_matches()
            if not matches then return end
            local buf_id = matches.current.bufnr
            if require('mini.bufremove').delete(buf_id) then
              local f = function(i) return i.bufnr ~= buf_id end
              local items = vim.tbl_filter(f, minipick.get_picker_items() or {})
              minipick.set_picker_items(items)
            end
          end,
        },
      },
    })
  end, { desc = 'Buffers' })

  local minipick = require('mini.pick')
  minipick.setup({
    window = {
      config = function()
        local height = math.floor(0.35 * vim.o.lines)
        local has_tabline = vim.o.showtabline == 2
          or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
        return {
          height = height,
          anchor = 'NW',
          row = has_tabline and 1 or 0,
          col = 0,
          border = vim.g.border,
        }
      end,
    },
  })
  for name, func in pairs(require('pickers')) do
    minipick.registry[name] = func
  end
end)
