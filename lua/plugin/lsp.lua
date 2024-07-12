local MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })
  require('mason').setup({
    ui = {
      border = vim.g.border,
      width = 0.8,
      height = 0.8,
    },
  })
end)

now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'pmizio/typescript-tools.nvim',
      'nvim-lua/plenary.nvim',
    },
  })
  local clangd_cap = vim.lsp.protocol.make_client_capabilities()
  clangd_cap.offsetEncoding = { 'utf-16' }
  local preview = { executable = 'firefox', args = { '%p' } }
  if vim.fn.has('wsl') == 1 then preview.executable = 'firefox.exe' end
  local auxdir = 'build'
  local servers = {
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
          auxDirectory = auxdir,
          bibtexFormatter = 'texlab',
          build = {
            executable = 'latexmk',
            args = {
              '-pdf',
              ('-output-directory=%s'):format(auxdir),
              ('-pdflatex="%s %s %s %%O %%S"'):format(
                '-interaction=nonstopmode',
                ('-aux-directory=%s'):format(auxdir),
                '-shell-escape'
              ),
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
            modifyLineBreaks = true,
            ['local'] = vim.fs.normalize(
              vim.fn.stdpath('config') .. '/latexindent/indentconfig.yaml'
            ),
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
  }
  local capabilities =
    require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local function setup(server)
    local server_opts = vim.tbl_deep_extend('force', {
      capabilities = vim.deepcopy(capabilities),
    }, servers[server] or {})

    require('lspconfig')[server].setup(server_opts)
  end

  local mlsp = require('mason-lspconfig')
  local available = mlsp.get_available_servers()

  for server, _ in pairs(servers) do
    if not vim.tbl_contains(available, server) then setup(server) end
  end

  mlsp.setup({ handlers = { setup } })
  require('lspconfig.ui.windows').default_options.border = vim.g.border

  require('typescript-tools').setup({})
end)

now(function()
  add({ source = 'folke/lazydev.nvim', depends = { 'Bilal2453/luvit-meta' } })
  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'Lazy%a' } },
    },
  })
end)

later(function()
  add({ source = 'lostl1ght/lightbulb.nvim' })
  require('lightbulb').setup({ virtual_text = { spacing = 1 } })
end)
