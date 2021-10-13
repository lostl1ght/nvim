local M = {}

-- Which-key setup
function M.setup()
    require'which-key'.setup{
        triggers_blacklist = {
            i = { 'i' },
            v = { 'i' },
        },
        key_labels = {
            ['<space>'] = 'SPC',
            ['<cr>'] = 'RET',
            ['<tab>'] = 'TAB',
        },
    }
end

-- Default vim bindings
function M.register()
    require'which-key'.register({
        ['<leader>'] = {
            w = {
                name = '+window',
                q = { '<C-w>q', 'Close window' },
                v = { '<C-w>v', 'Vertical split' },
                s = { '<C-w>s', 'Horizontal split' },
            },
            ['<tab>'] = {
                name = '+tabs',
                ['0'] = { '1gt', 'Switch to tab 1' },
                ['1'] = { '2gt', 'Switch to tab 2' },
                ['2'] = { '3gt', 'Switch to tab 3' },
                ['3'] = { '4gt', 'Switch to tab 4' },
                ['4'] = { '5gt', 'Switch to tab 5' },
                ['5'] = { '6gt', 'Switch to tab 6' },
                ['6'] = { '7gt', 'Switch to tab 7' },
                ['7'] = { '8gt', 'Switch to tab 8' },
                ['8'] = { '9gt', 'Switch to tab 9' },
                ['-1'] = { '<cmd>tablast<cr>', 'Switch to the last tab' },
                c = { '<cmd>tabnew<cr>', 'New tab' },
                n = { '<cmd>tabn<cr>', 'Next tab' },
                p = { '<cmd>tabp<cr>', 'Previous tab' },
            },
            l = { '<cmd>tabn<cr>', 'Next tab' },
            h = { '<cmd>tabp<cr>', 'Previous tab' },
            q = {
                name = '+quit',
                q = { '<cmd>qa<cr>', 'Quit' },
                Q = { '<cmd>qa!<cr>', 'Quit without saving' },
                s = { '<cmd>x<cr>', 'Save and quit' },
            },
            f = {
                name = '+file',
                n = { '<cmd>enew<cr>', 'New file' },
                s = { '<cmd>w<cr>', 'Save' },
                f = { '<cmd>lua require("telescope.builtin").find_files()<cr>', 'Open file' },
                w = { '<cmd>lua require("telescope.builtin").live_grep()<cr>', 'Find word' },
                h = { '<cmd>lua require("telescope.builtin").help_tags()<cr>', 'Help tags' },
                e = { '<cmd>lua require("telescope.builtin").file_browser()<cr>', 'File browser' },
                r = { '<cmd>lua require("telescope.builtin").oldfiles()<cr>', 'Recent file' },
            },
            b = {
                name = '+buffer',
                d = { '<cmd>bd<cr>', 'Delete buffer' },
                n = { '<cmd>bn<cr>', 'Next buffer' },
                p = { '<cmd>bp<cr>', 'Previous buffer' },
                b = { '<cmd>b#<cr>', 'Switch buffer' },
                f = { '<cmd>bf<cr>', 'First buffer' },
                l = { '<cmd>bl<cr>', 'Last buffer' },
                c = { '<cmd>%bd|e#<cr>', 'Clear buffers' },
                s = { '<cmd>Telescope buffers<cr>', 'Open buffer' },
            },
            d = {
                name = '+debug',
                s = { '<cmd>lua require("dapui").open()<cr> <cmd>lua require("dap").continue()<cr>', 'Start' },
                c = { '<cmd>lua require("dap").continue()<cr>', 'Continue' },
                e = { '<cmd>lua require("dap").disconnect()<cr> <cmd>lua require("dap").close()<cr> <cmd>lua require("dapui").close()<cr> <C-w>j <cmd>lua require("core.util").close_term()<cr>', 'End' },
            },
            o = {
                name = '+open',
                d = { '<cmd>lua require("dapui").toggle()<cr>', 'Debugger' },
                b = { '<cmd>DBUIToggle<cr>', 'Database' },
                m = { '<cmd>MarkdownPreviewToggle<cr>', 'Markdown preview' },
                t = { '<cmd>NvimTreeToggle<cr>', 'File tree' },
            },
            c = {
                name = '+code',
                f = { '<cmd>Format<cr>', 'Format' },
                n = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
                D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Declaration' },
                --[[d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Definition' },
                i = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Implementation' },
                r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'References' },
                t = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Type definition' },
                a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action' },]]--
                d = { '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>', 'Definition' },
                i = { '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>', 'Implementation' },
                r = { '<cmd>lua require("telescope.builtin").lsp_references()<cr>', 'References' },
                t = { '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>', 'Type definition' },
                a = { '<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>', 'Code action' },
                s = { '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>', 'Document symbols' },
                e = { '<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>', 'Document symbols' },
            },
            g = {
                name = '+git',
                g = { '<cmd>lua require("neogit").open({kind="vsplit"})<cr>', 'Open neogit' },
                s = { '<cmd>lua require("gitsigns").stage_hunk()<cr>', 'Stage hunk' },
                u = { '<cmd>lua require("gitsigns").undo_stage_hunk()<cr>', 'Undo stage hunk' },
                r = { '<cmd>lua require("gitsigns").reset_hunk()<cr>', 'Reset hunk' },
                R = { '<cmd>lua require("gitsigns").reset_buffer()<cr>', 'Reset buffer' },
                p = { '<cmd>lua require("gitsigns").preview_hunk()<cr>', 'Preview hunk' },
                b = { '<cmd>lua require("gitsigns").blame_line(true)<cr>'; 'Blame line' },
                S = { '<cmd>lua require("gitsigns").stage_buffer()<cr>', 'Stage buffer' },
                U = { '<cmd>lua require("gitsigns").reset_buffer_index()<cr>', 'Reset buffer index' },
                d = {
                    name = '+diff',
                    d = { '<cmd>DiffviewOpen<cr>', 'Open diffs' },
                    c = { '<cmd>DiffviewClose<cr>', 'Close diffs' },
                },
            },
            ['<space>'] = {
                name = '+hop',
                w = { '<cmd>HopWordAC<cr>', 'Hop word before' },
                b = { '<cmd>HopWordBC<cr>', 'Hop word after' },
                c = { '<cmd>HopChar1<cr>', 'Hop char' },
                l = { '<cmd>HopLine<cr>', 'Hop line' },
            },
            j = {
                name = '+ipython',
                e = { '<cmd>IPythonCellExecuteCellJump<cr>', 'Execute cell' },
                n = { '<cmd>IPythonCellNextCell<cr>', 'Next cell' },
                p = { '<cmd>IPythonCellPrevCell<cr>', 'Previous cell' },
                a = { '<cmd>IPythonCellInsertAbove<cr>', 'Insert cell above' },
                b = { '<cmd>IPythonCellInsertBelow<cr>', 'Insert cell below' },
            },
            s = {
                name = '+session',
                s = { '<cmd>Telescope sessions<cr>', 'Open session' },
                l = { '<cmd>LoadSession<cr>', 'Last session' },
                k = { '<cmd>SaveSession<cr>', 'Save session' },

            },
            --[[t = {
                name = '+term',
                t = { '<cmd>exe v:count1 . "ToggleTerm"<cr>', 'Toggle terminal' },
                o = { '<cmd>ToggleTermOpenAll<cr>', 'Open all terminals' },
                c = { '<cmd>ToggleTermCloseAll<cr>', 'Close all terminals' },
            },]]--
            p = { '<cmd>Telescope sessions<cr>', 'Open session' },
            [','] = { '<cmd>Telescope find_files<cr>', 'Open file' },
            ['.'] = { '<cmd>Telescope buffers<cr>', 'Open buffer' },
            ['/'] = { '<cmd>b#<cr>', 'Switch buffer' },
        },
        ['['] = {
            b = { '<cmd>bp<cr>', 'Previous buffer' },
            B = { '<cmd>bf<cr>', 'Previous buffer' },
            t = { '<cmd>tabp<cr>', 'Previous tab' },
            T = { '<cmd>tabl<cr>', 'Previous tab' },
            c = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', 'Previous code error' },
            h = { '<cmd>lua require("gitsigns.actions").prev_hunk()<cr>', 'Previous hunk' },
        },
        [']'] = {
            b = { '<cmd>bn<cr>', 'Next buffer' },
            B = { '<cmd>bl<cr>', 'Next buffer' },
            t = { '<cmd>tabn<cr>', 'Next tab' },
            T = { '<cmd>tabf<cr>', 'Next tab' },
            c = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'Next code error' },
            h = { '<cmd>lua require("gitsigns.actions").next_hunk()<cr>', 'Next hunk' },
        },
        K = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover' },
        ['<f9>'] = { '<cmd>lua require("dap").toggle_breakpoint()<cr>', 'Toggle breakpoint' },
        ['<f10>'] = { '<cmd>lua require("dap").step_over()<cr>', 'Step over' },
        ['<f11>'] = { '<cmd>lua require("dap").step_into()<cr>', 'Step into' },
        ['<f12>'] = { '<cmd>lua require("dap").step_out()<cr>', 'Step out' },
    },
    { mode = 'n' })

    require('which-key').register({
        ['<leader>'] = {
            d = {
                name = '+debug',
                e = { '<cmd>lua require("dapui").eval()<cr>', 'Eval expression' },
            },
            g = {
                name = '+git',
                h = { '<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Stage hunk' },
                r = { '<cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Reset hunk' },
            },
        },
    },
    { mode = 'v' })

    require('which-key').register({
        ['ih'] = { ':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk' }
    },
    { mode = 'x' })

    require('which-key').register({
        ['ih'] = { ':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk' }
    },
    { mode = 'o' })

end

return M
