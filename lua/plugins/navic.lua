return {
  'SmiteshP/nvim-navic',
  config = function()
    require('nvim-navic').setup({
      icons = {
        File = ' ',
        Module = ' ',
        Namespace = ' ',
        Package = ' ',
        Class = ' ',
        Method = ' ',
        Property = ' ',
        Field = ' ',
        Constructor = ' ',
        Enum = ' ',
        Interface = ' ',
        Function = ' ',
        Variable = ' ',
        Constant = ' ',
        String = ' ',
        Number = ' ',
        Boolean = ' ',
        Array = ' ',
        Object = ' ',
        Key = ' ',
        Null = ' ',
        EnumMember = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      },
      highlight = true,
    })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('LspNavic', {}),
      callback = function(data)
        local client = vim.lsp.get_client_by_id(data.data.client_id)
        if not client then
          return
        end
        if client.server_capabilities.documentSymbolProvider then
          local ok, navic = pcall(require, 'nvim-navic')
          if ok then
            navic.attach(client, data.buf)
          end
        end
      end,
    })
  end,
}
