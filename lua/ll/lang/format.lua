local present, formatter = pcall(require, 'formatter')
if not present then
    return print('formatter not found')
end

local clang = {
    -- clang-format
    function()
        return {
            exe = 'clang-format',
            args = { '--assume-filename', vim.api.nvim_buf_get_name(0) },
            stdin = true,
            cwd = vim.fn.expand('%:p:h'), -- Run clang-format in cwd of the file.
        }
    end,
}

local rustfmt = {
    -- rustfmt
    function()
        return {
            exe = 'rustfmt',
            args = { '--emit=stdout' },
            stdin = true,
        }
    end,
}

local stylua = {
    -- stylua
    function()
        return {
            exe = 'stylua',
            args = {
                '--config-path ' .. os.getenv('HOME') .. '/.config/stylua/stylua.toml',
                '-',
            },
            stdin = true,
        }
    end,
}

local autopep8 = {
    -- autopep8
    function()
        return {
            exe = 'autopep8',
            args = {
                '--in-place --aggressive --aggressive',
                vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
            },
            stdin = false,
        }
    end,
}

local yapf = {
    -- yapf
    function()
        return {
            exe = 'yapf',
            args = { '--style google', vim.api.nvim_buf_get_name(0) },
            stdin = true,
        }
    end,
}

formatter.setup({
    filetype = {
        c = clang,
        cpp = clang,
        lua = stylua,
        python = yapf,
        rust = rustfmt,
    },
})
