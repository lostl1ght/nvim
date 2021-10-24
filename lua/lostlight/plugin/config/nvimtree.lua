local d_present, devicons = pcall(require, 'nvim-web-devicons')
local t_present, tree = pcall(require, 'nvim-tree')
if not d_present or not t_present then
    return
end

-- Nvim tree setup
devicons.get_icons()

tree.setup{
    update_to_buf_dir = {
        enable = true,
    },
    update_cwd = true,
    update_focused_file = {
        enable      = true,
        update_cwd  = false,
    },
}
