---@type LazyPluginSpec
return {
  'echasnovski/mini.trailspace',
  event = 'VeryLazy',
  cmd = 'Trim',
  config = function()
    require('mini.trailspace').setup()

    local function trim_state(buf)
      buf = buf or 0
      local val = vim.b[buf].trim_trailing_whitespace
      return val == nil and true or val
    end

    local function toggle_trim()
      local enabled = trim_state()
      vim.b.trim_trailing_whitespace = not enabled
      vim.notify(
        ('whitespace trimming %s'):format(enabled and 'disabled' or 'enabled'),
        vim.log.levels.INFO,
        { title = 'Neovim' }
      )
    end
    local function toggle_highlight()
      vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable
      require('mini.trailspace').highlight()
      local state = vim.b.minitrailspace_disable and 'disabled' or 'enabled'
      vim.notify(
        ('trailspace highlight %s'):format(state),
        vim.log.levels.INFO,
        { title = 'Neovim' }
      )
    end
    local cmd = 'Trim'
    local commands = {
      toggle_highlight = toggle_highlight,
      toggle_trim = toggle_trim,
    }
    vim.api.nvim_create_user_command(cmd, function(data)
      local prefix = require('util').parse(cmd, data.args)
      commands[prefix]()
    end, {
      nargs = 1,
      desc = 'Trim whitespace',
      complete = function(_, line)
        return require('util').complete(line, cmd, commands)
      end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function(data)
        local buf = data.buf
        local enabled = trim_state(buf)
        if enabled then
          local n_lines = vim.api.nvim_buf_line_count(buf)
          local last_nonblank = vim.fn.prevnonblank(n_lines)
          if last_nonblank < n_lines then
            vim.api.nvim_buf_set_lines(buf, last_nonblank, n_lines, true, {})
          end

          local winid = vim.fn.bufwinid(buf)
          local current_win = vim.api.nvim_get_current_win()
          if vim.api.nvim_win_is_valid(winid) and winid == current_win then
            local curpos = vim.api.nvim_win_get_cursor(winid)
            vim.api.nvim_win_call(winid, function()
              vim.cmd([[keeppatterns %s/\s\+$//e]])
              vim.api.nvim_win_set_cursor(winid, curpos)
            end)
          end
        end
      end,
      group = vim.api.nvim_create_augroup('TrimWhiteSpace', {}),
      desc = 'Trim trailing whitespace',
    })
  end,
}
