local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'echasnovski/mini.pick' })
  vim.ui.select = require('select').ui_select
  local guicursor = vim.opt.guicursor:get()
  local group = vim.api.nvim_create_augroup('MiniPickCursor', {})
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniPickStart',
    callback = function() vim.opt.guicursor = { 'n:hor1' } end,
    group = group,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniPickStop',
    callback = function() vim.opt.guicursor = guicursor end,
    group = group,
  })

  local set = vim.keymap.set
  set('n', '<leader>fg', '<cmd>Pick grep<cr>', { desc = 'Grep' })
  set('n', '<leader>b', function()
    local minipick = require('mini.pick')
    minipick.builtin.buffers({}, {
      source = {
        show = function(buf_id, items, query)
          vim.tbl_map(function(i) i.text = vim.fn.fnamemodify(i.text, ':~:.') end, items)
          minipick.default_show(buf_id, items, query, { show_icons = true })
        end,
      },
      mappings = {
        delete = {
          char = '<c-d>',
          func = function()
            local buf_id = minipick.get_picker_matches().current.bufnr
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
  set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Files' })

  local minipick = require('mini.pick')
  minipick.setup({
    window = {
      config = function()
        local height = math.floor(0.35 * vim.opt.lines:get())
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
  minipick.registry.folders = function(local_opts)
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

    local minifiles = require('mini.files')
    minifiles.close()
    local opts = {
      source = {
        items = items_func,
        show = function(buf_id, items, query)
          minipick.default_show(buf_id, items, query, { show_icons = true })
        end,
        name = 'Folders',
        choose = function(item)
          vim.schedule(function()
            minifiles.open(item, false)
            minifiles.reveal_cwd()
          end)
        end,
      },
      mappings = {
        stop = '',
        back = {
          char = '<esc>',
          func = function()
            minipick.stop()
            vim.defer_fn(function() minifiles.open(minifiles.get_latest_path(), true) end, 20)
          end,
        },
      },
    }
    minipick.start(opts)
  end
end)
