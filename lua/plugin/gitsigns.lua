local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'lewis6991/gitsigns.nvim' })
  require('gitsigns').setup({
    attach_to_untracked = true,
    current_line_blame = true,
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      ---@param mode string|string[]
      ---@param l string
      ---@param r string|function
      ---@param opts table?
      local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd('normal! ]c')
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Hunk forward' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd('normal! [c')
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'Hunk backward' })

      map('n', ']C', function() gs.nav_hunk('last') end, { desc = 'Hunk last' })
      map('n', '[C', function() gs.nav_hunk('first') end, { desc = 'Hunk first' })

      -- Actions
      map('n', 'gzs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', 'gzr', gs.reset_hunk, { desc = 'Reset hunk' })
      map(
        'v',
        'gzs',
        function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'Stage hunk' }
      )
      map(
        'v',
        'gzr',
        function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'Reset hunk' }
      )
      map('n', 'gzS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', 'gzu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', 'gzR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', 'gzp', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', 'gzb', gs.blame, { desc = 'Blame' })
      map('n', 'gzB', function() gs.blame_line({ full = true }) end, { desc = 'Blame line' })
      map('n', '\\e', function()
        local new_state = gs.toggle_deleted()
        local msg = new_state and 'diffdeleted' or 'nodiffdeleted'
        print(msg)
      end, { desc = 'Diff deleted' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { desc = 'Hunk' })

      local ok, miniclue = pcall(require, 'mini.clue')
      if ok then
        local cfg = vim.b[bufnr].miniclue_config or { clues = {} }
        local clue = { mode = 'n', keys = 'gz', desc = '+gitsigns' }
        table.insert(cfg.clues, clue)
        vim.b[bufnr].miniclue_config = cfg
        vim.schedule(function() miniclue.ensure_buf_triggers(bufnr) end)
      end
    end,
  })
end)
