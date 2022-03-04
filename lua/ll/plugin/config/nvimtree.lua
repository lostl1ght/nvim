local present, tree = pcall(require, 'nvim-tree')
if not present then
    return print('nvim-tree not found')
end

tree.setup({
    update_to_buf_dir = {
        enable = true,
    },
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
