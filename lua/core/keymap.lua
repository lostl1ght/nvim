local M = {}

local wk = require('which-key')

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
    wk.register({
        ['<leader>'] = {
            e = {
                name = '+window',
                q = {'<C-w>q', 'Close window'},
                v = {'<C-w>v', 'Vertical split'},
                s = {'<C-w>s', 'Horizontal split'},
            },
        },
    },
    {mode = 'n'})
end

function M.tab()
    wk.register({
        ['<leader>'] = {
            ['t'] = {
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
            },
            l = {':tabn<cr>', 'Next tab'},
            h = {':tabp<cr>', 'Previous tab'},
        },
        ['['] = {
            t = {':tabp<cr>', 'Previous tab'},
            T = {':tabf<cr>', 'First tab'},
        },
        [']'] = {
            t = {':tabn<cr>', 'Next tab'},
            T = {':tabl<cr>', 'Last tab'},
        },
    },
    {mode = 'n'})
end

function M.quit()
    wk.register({
        ['<leader>'] = {
            q = {
                name = '+quit',
                q = {':qa<cr>', 'Quit'},
                Q = {':qa!<cr>', 'Quit without saving'},
                s = {':xa<cr>', 'Save and quit'},
            },
        },
    },
    {mode = 'n'})
end

function M.telescope()
    wk.register({
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
    },
    {mode = 'n'})
end

function M.buffer()
    wk.register({
        ['<leader>'] = {
            b = {
                name = '+buffer',
                n = {':enew<cr>', 'New buffer'},
                d = {':bd<cr>', 'Delete buffer'},
                c = {':%bd|e#<cr>', 'Clear buffers'},
                a = {':wa<cr>', 'Save all'},
            },
            ['.'] = {':Telescope buffers<cr>', 'Open buffer'},
            ['/'] = {':b#<cr>', 'Switch buffer'},
            w = {':w<cr>', 'Save'},
        },
        ['['] = {
            b = {':bp<cr>', 'Previous buffer'},
            B = {':bf<cr>', 'First buffer'},
        },
        [']'] = {
            b = {':bn<cr>', 'Next buffer'},
            B = {':bl<cr>', 'Last buffer'},
        },
    },
    {mode = 'n'})
end

function M.debug()
    vim.cmd('command! DapBegin lua require("dapui").open()<cr> require("dap").continue()<cr>')
    vim.cmd('command! DapStop lua require("dap").disconnect() require("dap").close() require("dapui").close() vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, true, true), "")')
    vim.cmd('command! DapCloseTerm lua require("core.util").close_term()')
    vim.cmd('command! DapToggle lua require("dapui").toggle()')
    vim.cmd('command! DapContinue lua require("dap").continue()')
    vim.cmd('command! DapToggleBreakpoint lua require("dap").toggle_breakpoint()')
    vim.cmd('command! DapStepOver lua require("dap").step_over()')
    vim.cmd('command! DapStepInto lua require("dap").step_into()')
    vim.cmd('command! DapStepOut lua require("dap").step_out()')
    vim.cmd('command! DapEval lua require("dapui").eval()')
    wk.register({
        ['<leader>'] = {
            d = {
                name = '+debug',
                b = {':DapBegin<cr>', 'Begin'},
                c = {':DapContinue<cr>', 'Continue'},
                s = {':DapStop<cr> :DapCloseTerm<cr>', 'Stop'},
            },
            o = {
                d = {':DapToggle<cr>', 'Debugger'},
            },
        },
        ['<f9>'] = {':DapToggleBreakpoint<cr>', 'Toggle breakpoint'},
        ['<f10>'] = {':DapStepOver<cr>', 'Step over'},
        ['<f11>'] = {':DapStepInto<cr>', 'Step into'},
        ['<f12>'] = {':DapStepOut<cr>', 'Step out'},
    },
    {mode = 'n'})
    require('which-key').register({
        ['<leader>'] = {
            d = {
                name = '+debug',
                e = {':DapEval<cr>', 'Eval expression'},
            },
        },
    },
    {mode = 'v'})
end

function M.open()
    wk.register({
        ['<leader>'] = {
            o = {
                name = '+open',
                b = {':DBUIToggle<cr>', 'Database'},
                m = {':MarkdownPreviewToggle<cr>', 'Markdown preview'},
                t = {':NvimTreeToggle<cr>', 'File tree'},
            },
        },
    },
    {mode = 'n'})
end

function M.code()
    wk.register({
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
    },
    {mode = 'n'})
end

function M.git()
    wk.register({
        ['<leader>'] = {
            g = {
                name = '+git',
                g = {':lua require("neogit").open({kind="vsplit"})<cr>', 'Open neogit'},
                s = {':lua require("gitsigns").stage_hunk()<cr>', 'Stage hunk'},
                u = {':lua require("gitsigns").undo_stage_hunk()<cr>', 'Undo stage hunk'},
                r = {':lua require("gitsigns").reset_hunk()<cr>', 'Reset hunk'},
                R = {':lua require("gitsigns").reset_buffer()<cr>', 'Reset buffer'},
                p = {':lua require("gitsigns").preview_hunk()<cr>', 'Preview hunk'},
                b = {':lua require("gitsigns").blame_line(true)<cr>'; 'Blame line'},
                S = {':lua require("gitsigns").stage_buffer()<cr>', 'Stage buffer'},
                U = {':lua require("gitsigns").reset_buffer_index()<cr>', 'Reset buffer index'},
                d = {
                    name = '+diff',
                    d = {':DiffviewOpen<cr>', 'Open diffs'},
                    c = {':DiffviewClose<cr>', 'Close diffs'},
                },
            },
        },
        ['['] = {
            h = {':lua require("gitsigns.actions").prev_hunk()<cr>', 'Previous hunk'},
        },
        [']'] = {
            h = {':lua require("gitsigns.actions").next_hunk()<cr>', 'Next hunk'},
        },
    },
    {mode = 'n'})

    wk.register({
        ['<leader>'] = {
            g = {
                name = '+git',
                h = {':lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Stage hunk'},
                r = {':lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Reset hunk'},
            },
        },
    },
    {mode = 'v'})

    wk.register({
        ['ih'] = {':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk'}
    },
    {mode = 'x'})

    wk.register({
        ['ih'] = {':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk'}
    },
    {mode = 'o'})
end

function M.hop()
    wk.register({
        ['<leader>'] = {
            ['<space>'] = {
                name = '+hop',
                w = {':HopWord<cr>', 'Hop word'},
                c = {':HopChar1<cr>', 'Hop char'},
                l = {':HopLine<cr>', 'Hop line'},
            },
        },
    },
    {mode = 'n'})
end

function M.ipython()
    wk.register({
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
    },
    {mode = 'n'})
end

function M.session()
    wk.register({
        ['<leader>'] = {
            s = {
                name = '+session',
                s = {':Telescope sessions<cr>', 'Open session'},
                l = {':LoadSession<cr>', 'Last session'},
                k = {':SaveSession<cr>', 'Save session'},

            },
            p = {':Telescope sessions<cr>', 'Open session'},
        },
    },
    {mode = 'n'})
end

function M.register()
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
end

return M
