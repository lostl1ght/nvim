local present, wk = pcall(require, 'which-key')
if not present then
    return
end

local M = {}

local keymap_n = {}
local keymap_v = {}
local keymap_x = {}
local keymap_o = {}

function M.merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            M.merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

-- Which-key setup
function M.setup()
    wk.setup{
        triggers_blacklist = {
            i = {'i'},
            v = {'i'},
        },
        key_labels = {
            ['<space>'] = 'SPC',
            ['<cr>'] = 'RET',
            ['<tab>'] = 'TAB',
        },
    }
end

function M.window()
    M.merge(keymap_n, {
        ['<leader>'] = {
            w = {
                name = '+window',
                q = {'<C-w>q', 'Close window'},
                v = {'<C-w>v', 'Vertical split'},
                s = {'<C-w>s', 'Horizontal split'},
            },
        },
    })
end

function M.tab()
    M.merge(keymap_n, {
        ['<leader>'] = {
            ['<tab>'] = {
                name = '+tabs',
                ['1'] = {'1gt', 'Switch to tab 1'},
                ['2'] = {'2gt', 'Switch to tab 2'},
                ['3'] = {'3gt', 'Switch to tab 3'},
                ['4'] = {'4gt', 'Switch to tab 4'},
                ['5'] = {'5gt', 'Switch to tab 5'},
                ['6'] = {'6gt', 'Switch to tab 6'},
                ['7'] = {'7gt', 'Switch to tab 7'},
                ['8'] = {'8gt', 'Switch to tab 8'},
                ['9'] = {'9gt', 'Switch to tab 9'},
                ['0'] = {':tabl<cr>', 'Switch to the last tab'},
                n = {':tabnew<cr>', 'New tab'},
                q = {':tabclose<cr>', 'Close tab'},
            },
        },
        ['['] = {
            t = {':tabp<cr>', 'Previous tab'},
            T = {':tabf<cr>', 'First tab'},
        },
        [']'] = {
            t = {':tabn<cr>', 'Next tab'},
            T = {':tabl<cr>', 'Last tab'},
        },
    })
end

function M.quit()
    M.merge(keymap_n, {
        ['<leader>'] = {
            q = {
                name = '+quit',
                q = {':qa<cr>', 'Quit'},
                Q = {':qa!<cr>', 'Quit without saving'},
                s = {':xa<cr>', 'Save and quit'},
            },
        },
    })
end

function M.telescope()
    M.merge(keymap_n, {
        ['<leader>'] = {
            f = {
                name = '+file',
                f = {':Telescope find_files<cr>', 'Open file'},
                w = {':Telescope live_grep<cr>', 'Find word'},
                h = {':Telescope help_tags<cr>', 'Help tags'},
                e = {':Telescope file_browser<cr>', 'File browser'},
                r = {':Telescope oldfiles<cr>', 'Recent file'},
            },
            [','] = {':Telescope find_files<cr>', 'Open file'},
        },
    })
end

function M.buffer()
    M.merge(keymap_n, {
        ['<leader>'] = {
            b = {
                name = '+buffer',
                n = {':enew<cr>', 'New buffer'},
                d = {':bd<cr>', 'Close buffer'},
                D = {':bd!<cr>', 'Override close buffer'},
                c = {':%bd|e#<cr>', 'Clear buffers'},
                a = {':wa<cr>', 'Save all'},
                h = {':set hlsearch!<cr>', 'Toggle hlsearch'},
            },
            ['.'] = {':Telescope buffers<cr>', 'Open buffer'},
            ['/'] = {':b#<cr>', 'Switch buffer'},
            s = {':wa<cr>', 'Save'},
        },
        ['['] = {
            b = {':bp<cr>', 'Previous buffer'},
            B = {':bf<cr>', 'First buffer'},
        },
        [']'] = {
            b = {':bn<cr>', 'Next buffer'},
            B = {':bl<cr>', 'Last buffer'},
        },
    })
end

function M.debug()
    vim.cmd('command! DapBegin lua require("dapui").open()<cr> require("dap").continue()<cr>')
    vim.cmd('command! DapStop lua require("dap").disconnect() require("dap").close() require("dapui").close() require("mars.util").close_term()')
    vim.cmd('command! DapToggle lua require("dapui").toggle()')
    vim.cmd('command! DapContinue lua require("dap").continue()')
    vim.cmd('command! DapBreakpoint lua require("dap").toggle_breakpoint()')
    vim.cmd('command! DapStepOver lua require("dap").step_over()')
    vim.cmd('command! DapStepInto lua require("dap").step_into()')
    vim.cmd('command! DapStepOut lua require("dap").step_out()')
    vim.cmd('command! DapEval lua require("dapui").eval()')
    M.merge(keymap_n, {
        ['<leader>'] = {
            d = {
                name = '+debug',
                d = {':DapBegin<cr>', 'Begin'},
                c = {':DapContinue<cr>', 'Continue'},
                s = {':DapStop<cr>', 'Stop'},
                t = {':DapToggle<cr>', 'Toggle UI'},
            },
        },
        ['<f9>'] = {':DapBreakpoint<cr>', 'Toggle breakpoint'},
        ['<f10>'] = {':DapStepOver<cr>', 'Step over'},
        ['<f11>'] = {':DapStepInto<cr>', 'Step into'},
        ['<f12>'] = {':DapStepOut<cr>', 'Step out'},
    })
    M.merge(keymap_v, {
        ['<leader>'] = {
            d = {
                name = '+debug',
                e = {':DapEval<cr>', 'Eval expression'},
            },
        },
    })
end

function M.open()
    M.merge(keymap_n, {
        ['<leader>'] = {
            o = {
                name = '+open',
                b = {':DBUIToggle<cr>', 'Database'},
                m = {':MarkdownPreviewToggle<cr>', 'Markdown preview'},
                t = {':NvimTreeToggle<cr>', 'File tree'},
            },
        },
    })
end

function M.code()
    M.merge(keymap_n, {
        ['<leader>'] = {
            c = {
                name = '+code',
                f = {':Format<cr>', 'Format'},
                n = {':lua vim.lsp.buf.rename()<cr>', 'Rename'},
                D = {':lua vim.lsp.buf.declaration()<cr>', 'Declaration'},
                d = {':lua vim.lsp.buf.definition()<cr>', 'Definition'},
                i = {':lua vim.lsp.buf.implementation()<cr>', 'Implementation'},
                t = {':lua vim.lsp.buf.type_definition()<cr>', 'Type definition'},
                r = {':lua require("telescope.builtin").lsp_references()<cr>', 'References'},
                a = {':lua require("telescope.builtin").lsp_code_actions()<cr>', 'Code action'},
                s = {':lua require("telescope.builtin").lsp_document_symbols()<cr>', 'Document symbols'},
                e = {':lua require("telescope.builtin").lsp_document_diagnostics()<cr>', 'Document diagnostics'},
            },
        },
        ['['] = {
            c = {':lua vim.lsp.diagnostic.goto_prev()<cr>', 'Previous code error'},
        },
        [']'] = {
            c = {':lua vim.lsp.diagnostic.goto_next()<cr>', 'Next code error'},
        },
        K = {':lua vim.lsp.buf.hover()<cr>', 'Hover'},
    })
end

function M.lspsaga()
    M.merge(keymap_n, {
        ['<leader>'] = {
            c = {
                name = '+code',
                h = {':Format<cr>', 'Format'},
                n = {':Lspsaga rename<cr>', 'Rename'},
                f = {':Lspsaga lsp_finder<cr>', 'Find symbol'},
                d = {':Lspsaga preview_definition<cr>', 'Definition'},
                a = {':Lspsaga code_action<cr>', 'Code action'},
                e = {':Lspsaga show_line_diagnostics<cr>', 'Line diagnostics'},
            },
        },
        ['['] = {
            c = {':Lspsaga diagnostic_jump_prev<cr>', 'Previous code error'},
        },
        [']'] = {
            c = {':Lspsaga diagnostic_jump_next<cr>', 'Next code error'},
        },
        K = {':Lspsaga hover_doc<cr>', 'Hover'},
    })
end

function M.git()
    M.merge(keymap_n, {
        ['<leader>'] = {
            g = {
                name = '+git',
                g = {':LazyGit<cr>', 'Open lazygit'},
                s = {':lua require("gitsigns").stage_hunk()<cr>', 'Stage hunk'},
                u = {':lua require("gitsigns").undo_stage_hunk()<cr>', 'Undo stage hunk'},
                r = {':lua require("gitsigns").reset_hunk()<cr>', 'Reset hunk'},
                R = {':lua require("gitsigns").reset_buffer()<cr>', 'Reset buffer'},
                p = {':lua require("gitsigns").preview_hunk()<cr>', 'Preview hunk'},
                b = {':lua require("gitsigns").blame_line(true)<cr>'; 'Blame line'},
                S = {':lua require("gitsigns").stage_buffer()<cr>', 'Stage buffer'},
                U = {':lua require("gitsigns").reset_buffer_index()<cr>', 'Reset buffer index'},
            },
        },
        ['['] = {
            h = {':lua require("gitsigns.actions").prev_hunk()<cr>', 'Previous hunk'},
        },
        [']'] = {
            h = {':lua require("gitsigns.actions").next_hunk()<cr>', 'Next hunk'},
        },
    })

    M.merge(keymap_v, {
        ['<leader>'] = {
            g = {
                name = '+git',
                h = {':lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Stage hunk'},
                r = {':lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Reset hunk'},
            },
        },
    })

    M.merge(keymap_x, {
        ['ih'] = {':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk'}
    })

    M.merge(keymap_o, {
        ['ih'] = {':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk'}
    })
end

function M.hop()
    M.merge(keymap_n, {
        ['<leader>'] = {
            ['<space>'] = {
                name = '+hop',
                w = {':HopWord<cr>', 'Hop word'},
                c = {':HopChar1<cr>', 'Hop char'},
                l = {':HopLine<cr>', 'Hop line'},
            },
        },
    })
end

function M.ipython()
    M.merge(keymap_n, {
        ['<leader>'] = {
            j = {
                name = '+ipython',
                e = {':IPythonCellExecuteCellJump<cr>', 'Execute cell'},
                n = {':IPythonCellNextCell<cr>', 'Next cell'},
                p = {':IPythonCellPrevCell<cr>', 'Previous cell'},
                a = {':IPythonCellInsertAbove<cr>', 'Insert cell above'},
                b = {':IPythonCellInsertBelow<cr>', 'Insert cell below'},
            },
        },
    })
end

function M.session()
    M.merge(keymap_n, {
        ['<leader>'] = {
            k = {
                name = '+session',
                o = {':Telescope sessions save_current=true<cr>', 'Open session'},
                l = {':LoadSession<cr>', 'Last session'},
                k = {':SaveSession<cr>', 'Save session'},
                a = {':echo "lol"<cr>', 'desc'}
            },
            m = {':Telescope sessions save_current=true<cr>', 'Open session'},
        },
    })
end

M.setup()
M.buffer()
M.code()
M.debug()
M.git()
M.hop()
M.ipython()
M.open()
M.quit()
M.session()
M.tab()
M.telescope()
M.window()
wk.register(keymap_n, {mode = 'n'})
wk.register(keymap_v, {mode = 'v'})
wk.register(keymap_x, {mode = 'x'})
wk.register(keymap_o, {mode = 'o'})
