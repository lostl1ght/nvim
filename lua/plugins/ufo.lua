---@type LazyPluginSpec
return {
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    vim.opt.foldcolumn = 'auto'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    vim.keymap.set('n', 'zR', function()
      require('ufo').openAllFolds()
    end, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', function()
      require('ufo').closeAllFolds()
    end, { desc = 'Close all folds' })

    --[[
    local function round(number, decimals)
      local scale = 10 ^ decimals
      local c = 2 ^ 52 + 2 ^ 51
      return ((number * scale + c) - c) / scale
    end
    ]]

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local scrollviewWidth = 5
      local newVirtText = {}
      -- local percent = round((endLnum - lnum) / vim.fn.line('$', vim.fn.bufwinid(vim.fn.bufnr())) * 100, 0)
      local prefix = ' <--'
      local suffix = (' %d lines'):format(endLnum - lnum)
      local infoWidth = vim.fn.strdisplaywidth(suffix) + vim.fn.strdisplaywidth(prefix)
      local targetWidth = width - infoWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth + scrollviewWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth - scrollviewWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          curWidth = curWidth + chunkWidth
          break
        end
        curWidth = curWidth + chunkWidth
      end
      local fill = (' '):rep(width - infoWidth - curWidth - scrollviewWidth)
      table.insert(newVirtText, { prefix, 'MoreMsg' })
      table.insert(newVirtText, { fill, 'MoreMsg' })
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end
    require('ufo').setup({
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = handler,
    })
  end,
}
