return {
  'kosayoda/nvim-lightbulb',
  config = function()
    local config = {
      ignore = {
        clients = { 'null-ls' },
      },
      sign = {
        enabled = false,
      },
      virtual_text = {
        enabled = true,
        text = '󰌵',
        hl_mode = 'combine',
      },
    }
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      callback = function()
        require('nvim-lightbulb').update_lightbulb(config)
      end,
      group = vim.api.nvim_create_augroup('LightBulb', {}),
    })
  end,
}
