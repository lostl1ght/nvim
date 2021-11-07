local M = {}

function M:init()
    local cmd = vim.cmd

    local present, packer = pcall(require, 'packer')

    if not present then
        local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

        print('Cloning packer..')
        -- remove the dir before cloning
        vim.fn.delete(packer_path, 'rf')
        vim.fn.system({
            'git',
            'clone',
            'https://github.com/wbthomason/packer.nvim',
            '--depth',
            '20',
            packer_path,
        })

        cmd('packadd packer.nvim')
        present, packer = pcall(require, 'packer')

        if present then
            print('Packer cloned successfully.')
        else
            error("Couldn't clone packer !\nPacker path: " .. packer_path .. '\n' .. packer)
            return
        end
    end

    cmd('packadd packer.nvim')

    packer.init({
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'rounded' })
            end,
        },
        git = { clone_timeout = 600 },
        auto_clean = true,
        compile_on_sync = true,
        compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    })
    self.packer = packer
    return self
end

function M:load(plugins)
    return self.packer.startup(function()
        for _, plugin in ipairs(plugins) do
            use(plugin)
        end
    end)
end

return M
