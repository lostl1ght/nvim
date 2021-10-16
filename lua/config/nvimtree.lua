-- Nvim tree setup
require('nvim-web-devicons').get_icons()

require('nvim-tree').setup{
    update_to_buf_dir = {
        enable = true,
    },
    update_cwd = true,
    update_focused_file = {
        enable      = true,
        update_cwd  = false,
    },
}
