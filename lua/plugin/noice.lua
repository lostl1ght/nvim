local minideps = require('mini.deps')
local add, now = minideps.add, minideps.now

now(function()
  add({ source = 'folke/noice.nvim', depends = { 'MunifTanjim/nui.nvim' } })
  vim.opt.cmdheight = 0
  require('noice').setup({
    -- NOTE: bottom search & cmdline
    cmdline = {
      view = 'cmdline',
      format = { search_down = { view = 'cmdline' }, search_up = { view = 'cmdline' } },
    },
    -- NOTE: end
    messages = { view = 'mini', view_error = 'mini', view_warn = 'mini' },
    popupmenu = { backend = 'cmp' },
    notify = { view = 'mini' },
    redirect = { view = 'split', filter = { event = 'msg_show' } },
    lsp = {
      progress = {
        view = 'mini',
        format_done = {
          { '✓ ', hl_group = 'NoiceLspProgressSpinner' },
          { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
          { '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
        },
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = { opts = { position = { row = 2, col = 2 } } },
      signature = { opts = { position = { row = 2, col = 2 } } },
      message = { view = 'mini' },
      documentation = {
        opts = {
          border = { style = 'single', padding = { 0, 0 } },
          win_options = { concealcursor = '' },
        },
      },
    },
    views = {
      cmdline_popup = { position = { row = '10%', col = '50%' } },
      confirm = { zindex = 300, relative = 'cursor', position = { row = 2, col = 2 } },
      split = { enter = true },
      mini = { reverse = false, position = { row = 1, col = '100%' } },
    },
    routes = {
      -- Hide search count
      { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
      -- HACK: search echoes /<search string>, hide it
      { filter = { event = 'msg_show', kind = '', find = '^/.+' }, opts = { skip = true } },
      -- HACK: search echoes ?<search string>, hide it
      { filter = { event = 'msg_show', kind = '', find = '^%?.+' }, opts = { skip = true } },
      -- Long messages to split
      { filter = { event = 'msg_show', min_height = 20 }, view = 'cmdline_output' },
      -- Hide 'written' messages
      { filter = { event = 'msg_show', kind = '', find = 'written$' }, opts = { skip = true } },
    },
  })
  local set = vim.keymap.set
  set({ 'n', 'i', 's' }, '<c-d>', function()
    if not require('noice.lsp').scroll(4) then return '<c-d>' end
  end, { expr = true, desc = 'Scroll down' })
  set({ 'n', 'i', 's' }, '<c-u>', function()
    if not require('noice.lsp').scroll(-4) then return '<c-u>' end
  end, { expr = true, desc = 'Scroll up' })
  set('c', '<c-\\>', function()
    require('noice').redirect(vim.fn.getcmdline())
    vim.api.nvim_input('<c-c>')
  end, { desc = 'Redirect cmdline' })
end)
