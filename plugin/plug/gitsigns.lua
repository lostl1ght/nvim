local minideps = require('mini.deps')
local add, later = minideps.add, minideps.later

later(function()
  add({ source = 'lewis6991/gitsigns.nvim' })
  require('gitsigns').setup({
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = 'right_align',
    },
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
      local prefix = 'gz'
      map('n', prefix .. 's', gs.stage_hunk, { desc = 'Toggle stage hunk' })
      map('n', prefix .. 'r', gs.reset_hunk, { desc = 'Reset hunk' })
      map(
        'v',
        prefix .. 's',
        function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'Stage hunk' }
      )
      map(
        'v',
        prefix .. 'r',
        function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'Reset hunk' }
      )
      map('n', prefix .. 'S', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', prefix .. 'R', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', prefix .. 'p', gs.preview_hunk_inline, { desc = 'Preview hunk' })
      map('n', prefix .. 'b', gs.blame, { desc = 'Blame' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { desc = 'Hunk' })

      local ok, miniclue = pcall(require, 'mini.clue')
      if ok then
        local cfg = vim.b[bufnr].miniclue_config or { clues = {} }
        table.insert(cfg.clues, { mode = 'n', keys = prefix, desc = '+gitsigns' })
        table.insert(cfg.clues, { mode = 'x', keys = prefix, desc = '+gitsigns' })
        vim.b[bufnr].miniclue_config = cfg
        vim.schedule(function() miniclue.ensure_buf_triggers(bufnr) end)
      end
    end,
  })
end)
