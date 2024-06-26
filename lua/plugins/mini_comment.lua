---@type LazyPluginSpec
return {
  'echasnovski/mini.comment',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })
    end,
  },
  config = function()
    require('mini.comment').setup({
      options = {
        ignore_blank_line = true,
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    })
  end,
}
