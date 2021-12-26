local present, tree = pcall(require, 'nvim-tree')
if not present then
    return print('nvim-tree not found')
end

vim.g.nvim_tree_quit_on_open = 1

tree.setup({
    update_to_buf_dir = {
        enable = true,
    },
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
})
