local minideps = require('mini.deps')
local add, now, later = minideps.add, minideps.now, minideps.later

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
      'pmizio/typescript-tools.nvim',
      'nvim-lua/plenary.nvim',
      'saghen/blink.cmp',
    },
  })
  local auxdir = 'build'
  local servers = {
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
          forwardSearch = { executable = 'xdg-open', args = { '%p' } },
          latexFormatter = 'latexindent',
          latexindent = {
            modifyLineBreaks = true,
            ['local'] = vim.fs.normalize(vim.fn.stdpath('config') .. '/indentconfig.yaml'),
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
  local capabilities = require('blink-cmp').get_lsp_capabilities(nil, true)
  local function setup(server)
    local server_opts = vim.tbl_deep_extend('force', {
      capabilities = vim.deepcopy(capabilities),
    }, servers[server] or {})
    ---@diagnostic disable-next-line: inject-field
    if server == 'clangd' then server_opts.capabilities.offsetEncoding = { 'utf-8' } end

    require('lspconfig')[server].setup(server_opts)
  end

  local mlsp = require('mason-lspconfig')
  local available = mlsp.get_available_servers()

  for server, _ in pairs(servers) do
    if not vim.tbl_contains(available, server) then setup(server) end
  end

  mlsp.setup({ handlers = { setup } })

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

later(function() add({ source = 'lostl1ght/lightbulb.nvim' }) end)
