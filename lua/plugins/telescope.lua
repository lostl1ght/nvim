return {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  keys = {
    {
      '<leader>fg',
      function()
        vim.cmd({ cmd = 'Telescope', args = { 'live_grep' } })
      end,
      desc = 'Live grep',
    },
    {
      '<leader>ff',
      function()
        vim.cmd({ cmd = 'Telescope', args = { 'find_files' } })
      end,
      desc = 'Files',
    },
    {
      '<leader>bb',
      function()
        vim.cmd({ cmd = 'Telescope', args = { 'buffers' } })
      end,
      desc = 'Buffers',
    },
  },

  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')
    local action_state = require('telescope.actions.state')

    local function flash(prompt_bufnr)
      require('flash').jump({
        pattern = '^',
        label = { after = { 0, 0 } },
        search = {
          mode = 'search',
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
            end,
          },
        },
        action = function(match)
          local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
          picker:set_selection(match.pos[1] - 1)
        end,
      })
    end

    local function delete_buffer(prompt_bufnr)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local ok
      current_picker:delete_selection(function(selection)
        local force = vim.api.nvim_get_option_value('buftype', { buf = selection.bufnr })
          == 'terminal'

        ok = require('mini.bufremove').delete(selection.bufnr, force)
        return ok
      end)
      if ok then
        actions.move_to_top(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = {
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        mappings = {
          n = {
            s = flash,
          },
          i = {
            ['<esc>'] = actions.close,
            ['<m-p>'] = action_layout.toggle_preview,
            ['<c-s>'] = flash,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          -- no_ignore = true,
          previewer = false,
          -- theme = 'ivy',
          layout_strategy = 'center',
          sorting_strategy = 'ascending',
          layout_config = {
            height = 0.3,
            anchor = 'NW',
          },
        },
        live_grep = {
          layout_strategy = 'vertical',
          layout_config = {},
        },
        help_tags = {
          mappings = {
            i = {
              ['<cr>'] = 'select_vertical',
            },
            n = {
              ['<cr>'] = 'select_vertical',
            },
          },
        },
        buffers = {
          previewer = false,
          -- theme = 'ivy',
          layout_strategy = 'center',
          sorting_strategy = 'ascending',
          layout_config = {
            height = 0.3,
            anchor = 'NW',
          },
          mappings = {
            i = {
              ['<c-d>'] = delete_buffer,
              ['<c-u>'] = false,
              ['<m-d>'] = false,
            },
            n = {
              ['<m-d>'] = false
            }
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        find_folders = {
          hidden = true,
          mappings = {
            i = {
              ['<esc>'] = 'go_back',
            },
          },
        },
      },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('find_folders')
  end,
}
