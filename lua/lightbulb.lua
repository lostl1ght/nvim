local api, lsp, fn = vim.api, vim.lsp, vim.fn
local uv = vim.uv or vim.loop

local C = {
  options = {
    debounce = 100,
    enable_in_insert = false,
    ignored_clients = {},
    sign = {
      enabled = false,
      priority = 40,
      text = '',
      hl = 'LightBulbText',
    },
    virtual_text = {
      enabled = true,
      spacing = 0,
      priority = 80,
      text = '',
      hl = 'LightBulbVirtualText',
      hl_mode = 'combine',
    },
  },
}

C.setup = function(opts) C.options = vim.tbl_deep_extend('force', C.options, opts or {}) end

setmetatable(C, {
  __index = function(self, key) return self.options[key] end,
})

local H = {}

H.inrender_row = -1
H.inrender_buf = nil

H.ns_id = api.nvim_create_namespace('LightBulb')

if vim.fn.has('nvim-0.11') then
  H.supports_method = function(client, method, bufnr) return client:supports_method(method, bufnr) end
else
  H.supports_method = function(client, method, bufnr) return client.supports_method(method, bufnr) end
end

H.defined = false
if not H.defined then
  fn.sign_define(C.sign.hl, { text = C.sign.text, texthl = C.sign.hl })
  H.defined = true
end

---Updates current lightbulb
---@param bufnr number?
---@param position table?
H.update_extmark = function(bufnr, position)
  if not bufnr or not api.nvim_buf_is_valid(bufnr) then return end
  api.nvim_buf_clear_namespace(bufnr, H.ns_id, 0, -1)
  pcall(fn.sign_unplace, C.sign.hl, { id = H.inrender_row, buffer = bufnr })

  if not position then return end

  if C.sign.enabled then
    fn.sign_place(
      position.row + 1,
      C.sign.hl,
      C.sign.hl,
      bufnr,
      { lnum = position.row + 1, priority = C.sign.priority }
    )
  end

  if C.virtual_text.enabled then
    api.nvim_buf_set_extmark(bufnr, H.ns_id, position.row, 0, {
      priority = C.virtual_text.priority,
      virt_text = {
        {
          (' '):rep(C.virtual_text.spacing) .. C.virtual_text.text,
          C.virtual_text.hl,
        },
      },
      virt_text_pos = 'eol',
      hl_mode = C.virtual_text.hl_mode,
    })
  end

  H.inrender_row = position.row + 1
  H.inrender_buf = bufnr
end

---Queries the LSP servers and updates the lightbulb
---@param bufnr number
---@param position_encoding "utf-8"|"utf-16"|"utf-32"
H.render = function(bufnr, position_encoding)
  local params = lsp.util.make_range_params(0, position_encoding)
  ---@diagnostic disable-next-line: inject-field
  params.context = {
    diagnostics = vim.diagnostic.get(bufnr, { lnum = api.nvim_win_get_cursor(0)[1] - 1 }),
  }

  local position = { row = params.range.start.line, col = params.range.start.character }

  lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(_, result, _)
    if api.nvim_get_current_buf() ~= bufnr then return end

    H.update_extmark(bufnr, (result and #result > 0 and position) or nil)
  end)
end

H.timer = uv.new_timer()

---Ask @glepnir...
---@param buf number
H.update = function(buf, position_encoding)
  H.timer:stop()
  H.update_extmark(H.inrender_buf)
  H.timer:start(C.debounce, 0, function()
    H.timer:stop()
    vim.schedule(function()
      if api.nvim_buf_is_valid(buf) and api.nvim_get_current_buf() == buf then
        H.render(buf, position_encoding)
      end
    end)
  end)
end

local M = {}
M.setup_opt = C.setup

M.setup_au = function()
  local group_name = 'LightBulb'
  local group = api.nvim_create_augroup(group_name, { clear = true })
  api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(opt)
      local client = lsp.get_client_by_id(opt.data.client_id)
      if not client then return end
      if
        not H.supports_method(client, 'textDocument/codeAction')
        or vim.tbl_contains(C.ignored_clients, client.name)
      then
        return
      end

      local buf = opt.buf
      local local_group_name = group_name .. tostring(buf)
      local ok = pcall(api.nvim_get_autocmds, { group = local_group_name })
      if ok then return end
      local local_group = api.nvim_create_augroup(local_group_name, { clear = true })
      api.nvim_create_autocmd('CursorMoved', {
        group = local_group,
        buffer = buf,
        callback = function(args) H.update(args.buf, client.offset_encoding) end,
      })

      if not C.enable_in_insert then
        api.nvim_create_autocmd('InsertEnter', {
          group = local_group,
          buffer = buf,
          callback = function(args) H.update_extmark(args.buf) end,
        })
      end

      api.nvim_create_autocmd('BufLeave', {
        group = local_group,
        buffer = buf,
        callback = function(args) H.update_extmark(args.buf) end,
      })
    end,
  })

  api.nvim_create_autocmd('LspDetach', {
    group = group,
    callback = function(args) pcall(api.nvim_del_augroup_by_name, group_name .. tostring(args.buf)) end,
  })
end

return M
