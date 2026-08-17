local com = vim.api.nvim_create_user_command

com('PackUpdate', function() vim.pack.update() end, { desc = 'Update packages' })
