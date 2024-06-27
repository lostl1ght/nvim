---@type LazyPluginSpec
return {
  'lewis6991/gitsigns.nvim',

  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('gitsigns').setup({
      attach_to_untracked = true,
      current_line_blame = true,
      --[[
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      ]]
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        ---@param mode string|string[]
        ---@param l string
        ---@param r string|function
        ---@param opts table?
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous hunk' })

        -- Actions
        map('n', '<leader>us', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>ur', gs.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>us', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Stage hunk' })
        map('v', '<leader>ur', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Reset hunk' })
        map('n', '<leader>uS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>uu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>uR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>up', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>ub', gs.blame, { desc = 'Blame' })
        map('n', '<leader>uB', function()
          gs.blame_line({ full = true })
        end, { desc = 'Blame line' })
        map('n', '<leader>ud', gs.toggle_deleted, { desc = 'Diff deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { desc = 'Hunk' })

        local util = require('util')
        for _, mode in ipairs({ 'n', 'v' }) do
          util.set_mini_clue({
            key = '<leader>u',
            name = 'gitsigns',
            mode = mode,
            buf = bufnr,
          })
        end
      end,
    })
  end,
}
