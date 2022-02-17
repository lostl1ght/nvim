local present, wk = pcall(require, 'which-key')
if not present then
    return print('which-key not found')
end

local M = {}

local keymap_n = {}
local keymap_v = {}
local keymap_x = {}
local keymap_o = {}

M.merge = function(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
            M.merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

M.setup = function()
    wk.setup({
        triggers_blacklist = {
            i = { 'i' },
            v = { 'i' },
        },
        key_labels = {
            ['<space>'] = 'SPC',
            ['<cr>'] = 'RET',
            ['<tab>'] = 'TAB',
        },
    })
end

M.buffer = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            ['<tab>'] = { ':b#<cr>', 'Switch buffer' },
            b = {
                name = '+buffer',
                n = { ':enew<cr>', 'New buffer' },
                d = { ':bd<cr>', 'Close buffer' },
                D = { ':bd!<cr>', 'Force close buffer' },
                c = { ':lua require("ll.util").clear_normal()<cr>', 'Clear normal buffers' },
                C = { ':lua require("ll.util").clear_abnormal()<cr>', 'Clear abnormal buffers' },
                h = { ':set hlsearch!<cr>', 'Toggle hlsearch' },
                s = { ':b#<cr>', 'Switch buffer' },
                f = { ':Format<cr>', 'Format buffer' },
            },
            ['.'] = { ':Telescope buffers<cr>', 'Open buffer' },
            f = {
              s = { ':w<cr>', 'Save' },
              S = { ':wa<cr>', 'Save all' }
            },
        },
        ['['] = {
            b = { ':bp<cr>', 'Previous buffer' },
            B = { ':bf<cr>', 'First buffer' },
        },
        [']'] = {
            b = { ':bn<cr>', 'Next buffer' },
            B = { ':bl<cr>', 'Last buffer' },
        },
    })
end

M.git = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            g = {
                name = '+git',
                g = { ':LazyGit<cr>', 'Open lazygit' },
                s = { ':lua require("gitsigns").stage_hunk()<cr>', 'Stage hunk' },
                u = { ':lua require("gitsigns").undo_stage_hunk()<cr>', 'Undo stage hunk' },
                r = { ':lua require("gitsigns").reset_hunk()<cr>', 'Reset hunk' },
                R = { ':lua require("gitsigns").reset_buffer()<cr>', 'Reset buffer' },
                p = { ':lua require("gitsigns").preview_hunk()<cr>', 'Preview hunk' },
                b = { ':lua require("gitsigns").blame_line(true)<cr>', 'Blame line' },
                S = { ':lua require("gitsigns").stage_buffer()<cr>', 'Stage buffer' },
                U = { ':lua require("gitsigns").reset_buffer_index()<cr>', 'Reset buffer index' },
            },
        },
        ['['] = {
            h = { ':lua require("gitsigns.actions").prev_hunk()<cr>', 'Previous hunk' },
        },
        [']'] = {
            h = { ':lua require("gitsigns.actions").next_hunk()<cr>', 'Next hunk' },
        },
    })

    M.merge(keymap_v, {
        ['<leader>'] = {
            g = {
                name = '+git',
                h = { ':lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Stage hunk' },
                r = { ':lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>', 'Reset hunk' },
            },
        },
    })

    M.merge(keymap_x, {
        ['ih'] = { ':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk' },
    })

    M.merge(keymap_o, {
        ['ih'] = { ':<c-u>lua require("gitsigns.actions").select_hunk()<cr>', 'select hunk' },
    })
end

M.kitty = function()
    vim.g.kitty_navigator_no_mappings = 1
    M.merge(keymap_n, {
        ['<c-h>'] = { ':KittyNavigateLeft<cr>', 'Kitty Navigate Left' },
        ['<c-l>'] = { ':KittyNavigateRight<cr>', 'Kitty Navigate Right' },
        ['<c-j>'] = { ':KittyNavigateDown<cr>', 'Kitty Navigate Down' },
        ['<c-k>'] = { ':KittyNavigateUp<cr>', 'Kitty Navigate Up' },
    })
end


M.open = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            o = {
                name = '+open',
                m = { ':MarkdownPreviewToggle<cr>', 'Markdown preview' },
                t = { ':NvimTreeToggle<cr>', 'File tree' },
            },
        },
    })
end

M.packer = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            p = {
                name = '+packer',
                c = { ':PackerCompile<cr>', 'Compile' },
                s = { ':PackerSync<cr>', 'Sync' },
                i = { ':PackerInstall<cr>', 'Install' },
                w = { ':PackerClean<cr>', 'Clean' },
                t = { ':PackerStatus<cr>', 'Status' },
            },
        },
    })
end

M.quit = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            q = { ':qa<cr>', 'Quit' },
            Q = { ':qa!<cr>', 'Quit without saving' },
        },
    })
end

M.session = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            k = {
                name = '+session',
                o = { ':Telescope sessions save_current=true<cr>', 'Open session' },
                l = { ':LoadSession<cr>', 'Last session' },
                k = { ':SaveSession<cr>', 'Save session' },
            },
            m = { ':Telescope sessions save_current=true<cr>', 'Open session' },
        },
    })
end

M.tab = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            ['<tab>'] = {
                name = '+tabs',
                ['1'] = { '1gt', 'Switch to tab 1' },
                ['2'] = { '2gt', 'Switch to tab 2' },
                ['3'] = { '3gt', 'Switch to tab 3' },
                ['4'] = { '4gt', 'Switch to tab 4' },
                ['5'] = { '5gt', 'Switch to tab 5' },
                ['6'] = { '6gt', 'Switch to tab 6' },
                ['7'] = { '7gt', 'Switch to tab 7' },
                ['8'] = { '8gt', 'Switch to tab 8' },
                ['9'] = { '9gt', 'Switch to tab 9' },
                ['0'] = { ':tabl<cr>', 'Switch to the last tab' },
                n = { ':tabnew<cr>', 'New tab' },
                q = { ':tabclose<cr>', 'Close tab' },
            },
        },
        ['['] = {
            t = { ':tabp<cr>', 'Previous tab' },
            T = { ':tabf<cr>', 'First tab' },
        },
        [']'] = {
            t = { ':tabn<cr>', 'Next tab' },
            T = { ':tabl<cr>', 'Last tab' },
        },
    })
end

M.telescope = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            f = {
                name = '+file',
                f = { ':Telescope find_files<cr>', 'Open file' },
                w = { ':Telescope live_grep<cr>', 'Find word' },
                h = { ':Telescope help_tags<cr>', 'Help tags' },
            },
            [','] = { ':Telescope find_files<cr>', 'Open file' },
        },
    })
end

M.terminal = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            t = { ':terminal<cr>', 'Terminal' },
            T = { ':tabnew term://$SHELL<cr>', 'Tab terminal' },
        },
    })
end

M.window = function()
    M.merge(keymap_n, {
        ['<leader>'] = {
            w = {
                name = '+window',
                d = { '<C-w>q', 'Close window' },
                v = { '<C-w>v', 'Vertical split' },
                s = { '<C-w>s', 'Horizontal split' },
            },
        },
    })
end

M.setup()

M.buffer()
M.git()
M.kitty()
M.open()
M.packer()
M.quit()
M.session()
-- M.tab()
M.telescope()
M.terminal()
M.window()

wk.register(keymap_n, { mode = 'n' })
wk.register(keymap_v, { mode = 'v' })
wk.register(keymap_x, { mode = 'x' })
wk.register(keymap_o, { mode = 'o' })
