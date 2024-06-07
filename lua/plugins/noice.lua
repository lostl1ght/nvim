return {
  'folke/noice.nvim',
  lazy = false,
  keys = {
    {
      '<c-d>',
      function()
        if not require('noice.lsp').scroll(4) then
          return '<c-d>'
        end
      end,
      desc = 'Scroll down',
      expr = true,
      mode = { 'n', 'i', 's' },
    },
    {
      '<c-u>',
      function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-u>'
        end
      end,
      desc = 'Scroll up',
      expr = true,
      mode = { 'n', 'i', 's' },
    },
    {
      '<c-space>',
      function()
        require('noice').redirect(vim.fn.getcmdline())
      end,
      desc = 'Redirect cmdline',
      mode = 'c',
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('noice').setup({
      cmdline = {
        view = 'cmdline',
        format = {
          search_down = {
            view = 'cmdline',
          },
          search_up = {
            view = 'cmdline',
          },
        },
      },
      messages = {
        view = 'mini',
        view_error = 'mini',
        view_warn = 'mini',
      },
      popupmenu = {
        backend = 'cmp',
      },
      notify = {
        view = 'mini',
      },
      redirect = {
        view = 'split',
        filter = { event = 'msg_show' },
      },
      lsp = {
        progress = {
          view = 'mini',
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = {
          opts = {
            position = { row = 2, col = 2 },
          },
        },
        signature = {
          opts = {
            position = { row = 2, col = 2 },
          },
        },
        message = {
          view = 'mini',
        },
        documentation = {
          opts = {
            border = { style = 'single', padding = { 0, 0 } },
            win_options = {
              concealcursor = '',
            },
          },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = '10%',
            col = '50%',
          },
        },
        confirm = {
          zindex = 500,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = 'search_count',
          },
          opts = { skip = true },
        },
        --[[
        -- Not needed since null-ls archived (and gitsigns code actions)
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            find = 'code_action',
          },
          opts = { skip = true },
        },
        ]]
      },
    })
  end,
}
