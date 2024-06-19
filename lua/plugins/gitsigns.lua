return {
  'lewis6991/gitsigns.nvim',

  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('gitsigns').setup({
      attach_to_untracked = true,
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
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
        map('n', '<leader>ub', function()
          gs.blame_line({ full = true })
        end, { desc = 'Blame line' })
        map('n', '<leader>uB', gs.toggle_current_line_blame, { desc = 'Current line blame' })
        map('n', '<leader>ud', gs.diffthis, { desc = 'Diff against index' })
        map('n', '<leader>ud', function()
          gs.diffthis('~')
        end, { desc = 'Diff against last commit' })
        map('n', '<leader>tD', gs.toggle_deleted, { desc = 'Diff deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Hunk' })
        local ok, wk = pcall(require, 'which-key')
        if ok then
          wk.register({
            ['<leader>u'] = { name = 'gitsigns' },
          }, { buffer = bufnr, mode = { 'n', 'v' } })
        end
      end,
    })
  end,
}
