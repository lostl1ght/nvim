return {
  'L3MON4D3/LuaSnip',
  build = 'make install_jsregexp',
  --[[
  keys = {
    {
      '<c-j>',
      function()
        if require('luasnip').jumpable() then
          require('luasnip').jump(1)
        end
      end,
      mode = { 'i', 's' },
      desc = 'Snippet: jump forward',
    },
    {
      '<c-k>',
      function()
        if require('luasnip').jumpable() then
          require('luasnip').jump(-1)
        end
      end,
      mode = { 'i', 's' },
      desc = 'Snippet: jump backward',
    },
  },
  ]]
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
}
