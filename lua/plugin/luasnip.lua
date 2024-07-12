local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({
    source = 'L3MON4D3/LuaSnip',
    hooks = {
      post_install = function(spec)
        later(function()
          vim.system(
            { 'make', '-C', spec.path, 'install_jsregexp' },
            { text = true },
            function(obj)
              vim.notify(
                'Finished building `LuaSnip`; code ' .. obj.code,
                obj.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
              )
            end
          )
        end)
      end,
    },
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  local set = vim.keymap.set
  set({ 'i', 's' }, '<c-f>', function()
    if require('luasnip').jumpable() then require('luasnip').jump(1) end
  end)
  set({ 'i', 's' }, '<c-b>', function()
    if require('luasnip').jumpable(-1) then require('luasnip').jump(-1) end
  end)
end)
