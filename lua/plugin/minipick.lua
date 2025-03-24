local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.pick', depends = { 'echasnovski/mini.icons' } })
  vim.ui.select = require('select').ui_select

  local set = vim.keymap.set
  set('n', 'gfg', '<cmd>Pick grep<cr>', { desc = 'Grep' })
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
          vim.tbl_map(function(i)
            local path = vim.uv.fs_realpath(vim.fn.fnamemodify(i.text, ':p'))
            if path then i.text = vim.fn.fnamemodify(path, ':~:.') end
          end, items)
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
  set('n', 'gff', '<cmd>Pick files<cr>', { desc = 'Files' })

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
  minipick.registry.folders = function(local_opts, opts)
    local fd
    if vim.fn.executable('fd') == 1 then
      fd = 'fd'
    elseif vim.fn.executable('fdfind') == 1 then
      fd = 'fdfind'
    end

    local items_func

    if fd then
      local command = { fd, '--type', 'd', '--color', 'never' }
      if local_opts.hidden then table.insert(command, '--hidden') end
      if local_opts.no_ignore then table.insert(command, '--no-ignore') end
      items_func = vim.schedule_wrap(function() minipick.set_picker_items_from_cli(command) end)
    else
      items_func = vim.schedule_wrap(function()
        minipick.set_picker_items(
          vim
            .iter(vim.fs.dir(vim.uv.cwd() or '.', { depth = math.huge }))
            :filter(function(_, type) return type == 'directory' end)
            :map(function(item) return item .. '/' end)
            :totable()
        )
      end)
    end

    local prefix
    if local_opts.hidden and local_opts.no_ignore then
      prefix = 'Hidden and ignored f'
    elseif local_opts.hidden then
      prefix = 'Hidden f'
    elseif local_opts.no_ignore then
      prefix = 'Ignored f'
    else
      prefix = 'F'
    end

    local minifiles = require('mini.files')
    minifiles.close()
    local default_opts = {
      source = {
        name = prefix .. 'olders',
        show = function(buf_id, items, query)
          minipick.default_show(buf_id, items, query, { show_icons = true })
        end,
        choose = function(item)
          vim.schedule(function()
            minifiles.open(item, false)
            minifiles.reveal_cwd()
          end)
        end,
      },
    }
    minipick.start(vim.tbl_deep_extend('force', default_opts, opts or {}, {
      source = { items = items_func },
    }))
  end
end)
