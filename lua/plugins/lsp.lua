---@type LazyPluginSpec
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
    { 'kosayoda/nvim-lightbulb' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
      'pmizio/typescript-tools.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    { 'folke/trouble.nvim' },
  },
  opts = function()
    local clangd_cap = vim.lsp.protocol.make_client_capabilities()
    clangd_cap.offsetEncoding = { 'utf-16' }
    local preview
    if vim.fn.has('wsl') == 1 then
      preview = {
        executable = 'sumatra.exe',
        args = { '%p' },
      }
    else
      preview = {
        executable = 'evince-synctex',
        args = { '-f', '%l', '%p' },
      }
    end
    return {
      servers = {
        clangd = {
          capabilities = clangd_cap,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { autoRequire = false, keywordSnippet = 'Disable' },
              diagnostics = {
                disable = { 'trailing-space', 'missing-fields' },
                unusedLocalExclude = { '_*' },
              },
              hint = {
                enable = true,
              },
              runtime = {
                pathStrict = true,
              },
              telemetry = { enable = false },
              workspace = {
                checkThirdParty = false,
              },
              doc = {
                privateName = { '^_' },
              },
            },
          },
        },
        rust_analyzer = {
          name = 'rust-analyzer',
          -- settings = { ['rust-analyzer'] = { completion = { postfix = { enable = false } } } },
        },
        texlab = {
          settings = {
            texlab = {
              auxDirectory = 'build',
              bibtexFormatter = 'texlab',
              build = {
                executable = 'latexmk',
                args = {
                  '-pdf',
                  '-interaction=nonstopmode',
                  '-shell-escape',
                  '-synctex=1',
                  '-outdir=build',
                  '%f',
                },
                forwardSearchAfter = false,
                onSave = false,
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = false,
              },
              diagnosticsDelay = 300,
              diagnostics = { ignoredPatterns = { 'Undefined reference' } },
              formatterLineLength = 80,
              forwardSearch = preview,
              latexFormatter = 'latexindent',
              latexindent = {
                modifyLineBreaks = false,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        -- PylspInstall pyls-isort pylsp-mypy pylsp-rope python-lsp-ruff
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                autopep8 = {
                  enabled = false,
                },
              },
            },
          },
        },
        emmet_language_server = {
          name = 'emmet',
        },
        cssls = {
          name = 'css-ls',
        },
        html = {
          name = 'html-ls',
        },
      },
      inlay_hints_enabled = false,
    }
  end,

  -- Servers:
  -----------------
  -- clangd
  -- lua-ls
  -- rust-analyzer
  -- texlab
  config = function(_, opts)
    local servers = opts.servers
    local capabilities =
      require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    --[[
  -- UFO
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  --]]
    local function setup(server)
      local server_opts = vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      require('lspconfig')[server].setup(server_opts)
    end

    local mlsp = require('mason-lspconfig')
    local available = mlsp.get_available_servers()

    for server, _ in pairs(servers) do
      if not vim.tbl_contains(available, server) then
        setup(server)
      end
    end

    mlsp.setup({ handlers = { setup } })
    require('lspconfig.ui.windows').default_options.border = 'single'

    require('typescript-tools').setup({})

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('InlayHintsAttach', {}),
      callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.server_capabilities.inlayHintProvider then
          return
        end
        vim.lsp.inlay_hint.enable(opts.inlay_hints_enabled, { bufnr = buf })
        vim.b[buf].inlay_hints_enabled = opts.inlay_hints_enabled
      end,
    })
  end,
}
