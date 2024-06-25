return {
  'm-demare/hlargs.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local color
    if vim.g.colors_name == 'rose-pine' then
      color = '#eceff4'
    elseif vim.g.colors_name == 'kanagawa' then
      color = '#a3d4d5'
    end
    require('hlargs').setup({
      color = color,
      excluded_argnames = {
        declarations = {
          python = { 'self', 'cls' },
          lua = { 'self' },
        },
        usages = {
          python = { 'self', 'cls' },
          lua = { 'self' },
        },
      },
      hl_priority = 150,
    })
  end,
}
