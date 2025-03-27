local M = {}
local H = {}

M.lsp = function(local_opts, opts)
  local_opts = vim.tbl_deep_extend('force', { scope = nil, symbol_query = '' }, local_opts or {})
  if local_opts.scope == nil then
    vim.ui.select(H.allowed_scopes, { prompt = 'Select scope: ' }, function(scope)
      if scope == nil then return end
      local_opts.scope = scope
    end)
  end
  if local_opts.scope == nil then return end

  local scope = H.pick_validate_scope(local_opts, H.allowed_scopes, 'lsp')

  if scope == 'references' then
    return vim.lsp.buf[scope](nil, { on_list = H.lsp_make_on_list(local_opts.scope, opts) })
  end
  if scope == 'workspace_symbol' then
    local query = tostring(local_opts.symbol_query)
    return vim.lsp.buf[scope](query, { on_list = H.lsp_make_on_list(local_opts.scope, opts) })
  end
  vim.lsp.buf[scope]({ on_list = H.lsp_make_on_list(local_opts.scope, opts) })
end

H.allowed_scopes = {
  'declaration',
  'definition',
  'document_symbol',
  'implementation',
  'references',
  'type_definition',
  'workspace_symbol',
}

H.ns_id = { pickers = vim.api.nvim_create_namespace('MiniPickLsp') }

H.pick_start = function(items, default_opts, opts)
  local pick = require('mini.pick')
  local fallback = {
    source = {
      preview = pick.default_preview,
      choose = pick.default_choose,
      choose_marked = pick.default_choose_marked,
    },
  }
  local opts_final =
    vim.tbl_deep_extend('force', fallback, default_opts, opts or {}, { source = { items = items } })
  return pick.start(opts_final)
end

H.pick_highlight_line = function(buf_id, line, hl_group, priority)
  local opts =
    { end_row = line, end_col = 0, hl_mode = 'blend', hl_group = hl_group, priority = priority }
  vim.api.nvim_buf_set_extmark(buf_id, H.ns_id.pickers, line - 1, 0, opts)
end

H.pick_prepend_position = function(item)
  local path
  if item.path ~= nil then
    path = item.path
  elseif H.is_valid_buf(item.bufnr) then
    local name = vim.api.nvim_buf_get_name(item.bufnr)
    path = name == '' and ('Buffer_' .. item.bufnr) or name
  end
  if path == nil then return item end

  path = vim.fn.fnamemodify(path, ':p:.')
  local text = item.text or ''
  local suffix = text == '' and '' or ('│ ' .. text)
  item.text = string.format('%s│%s│%s%s', path, item.lnum or 1, item.col or 1, suffix)
  return item
end

H.pick_clear_namespace = function(buf_id, ns_id)
  pcall(vim.api.nvim_buf_clear_namespace, buf_id, ns_id, 0, -1)
end

H.pick_validate_one_of = function(target, opts, values, picker_name)
  if vim.tbl_contains(values, opts[target]) then return opts[target] end
  local msg = string.format(
    '`Picker %s` has wrong "%s" local option (%s). Should be one of %s.',
    picker_name,
    target,
    vim.inspect(opts[target]),
    table.concat(vim.tbl_map(vim.inspect, values), ', ')
  )
  H.error(msg)
end

H.pick_validate_scope = function(...) return H.pick_validate_one_of('scope', ...) end

H.pick_get_config = function()
  return vim.tbl_deep_extend(
    'force',
    (require('mini.pick') or {}).config or {},
    vim.b.minipick_config or {}
  )
end

H.show_with_icons = function(buf_id, items, query)
  require('mini.pick').default_show(buf_id, items, query, { show_icons = true })
end

H.lsp_make_on_list = function(source, opts)
  local is_symbol = source == 'document_symbol' or source == 'workspace_symbol'

  local ok, miniicons = pcall(require, 'mini.icons')

  -- Prepend file position info to item, add decortion, and sort
  local add_decor_data = function() end
  if is_symbol and ok then
    -- Try using '@...' style highlight group with same name as "kind"
    add_decor_data = function(item)
      item.hl = string.format('@%s', string.lower(item.kind or 'unknown'))
    end
  end
  if is_symbol and ok then
    add_decor_data = function(item)
      if type(item.kind) ~= 'string' then return end
      local icon, hl = miniicons.get('lsp', item.kind)
      -- If kind is not original, assume it already contains an icon
      local icon_prefix = item.kind_orig == item.kind and (icon .. ' ') or ''
      item.text, item.hl = icon_prefix .. item.text, hl
    end
  end

  local process = function(items)
    if source ~= 'document_symbol' then items = vim.tbl_map(H.pick_prepend_position, items) end
    -- Input `item.kind` is a string (resolved before `on_list`). Account for
    -- possibly tweaked symbol map (like after `MiniIcons.tweak_lsp_kind`).
    local kind_map = H.get_symbol_kind_map()
    for _, item in ipairs(items) do
      item.kind_orig, item.kind = item.kind, kind_map[item.kind]
      add_decor_data(item)
      item.kind_orig = nil
    end
    table.sort(items, H.lsp_items_compare)
    return items
  end

  local minipick = require('mini.pick')
  local show_explicit = H.pick_get_config().source.show
  local show = function(buf_id, items_to_show, query)
    if show_explicit ~= nil then return show_explicit(buf_id, items_to_show, query) end
    if is_symbol then
      minipick.default_show(buf_id, items_to_show, query)

      -- Highlight whole lines with pre-computed symbol kind highlight groups
      H.pick_clear_namespace(buf_id, H.ns_id.pickers)
      for i, item in ipairs(items_to_show) do
        H.pick_highlight_line(buf_id, i, item.hl, 199)
      end
      return
    end
    -- Show with icons as the non-symbol scopes should have paths
    return H.show_with_icons(buf_id, items_to_show, query)
  end

  local choose = function(item)
    minipick.default_choose(item)
    -- Ensure relative path in `:buffers` output with hacky workaround.
    -- `default_choose` ensures it with `bufadd(fnamemodify(path, ':.'))`, but
    -- somehow that doesn't work inside `on_list` of `vim.lsp.buf` methods.
    vim.fn.chdir(vim.fn.getcwd())
  end

  return function(data)
    local items = data.items
    for _, item in ipairs(data.items) do
      item.text, item.path = item.text or '', item.filename or nil
    end
    items = process(items)

    local source_opts = { name = string.format('LSP (%s)', source), show = show, choose = choose }
    return H.pick_start(items, { source = source_opts }, opts)
  end
end

H.get_symbol_kind_map = function()
  -- Compute symbol kind map from "resolved" string kind to its "original" (as in
  -- LSP protocol). Those can be different after `MiniIcons.tweak_lsp_kind()`.
  local res = {}
  local double_map = vim.lsp.protocol.SymbolKind
  for k, v in pairs(double_map) do
    if type(k) == 'string' and type(v) == 'number' then res[double_map[v]] = k end
  end
  return res
end

H.lsp_items_compare = function(a, b)
  local a_path, b_path = a.path or '', b.path or ''
  if a_path < b_path then return true end
  if a_path > b_path then return false end

  local a_lnum, b_lnum = a.lnum or 1, b.lnum or 1
  if a_lnum < b_lnum then return true end
  if a_lnum > b_lnum then return false end

  local a_col, b_col = a.col or 1, b.col or 1
  if a_col < b_col then return true end
  if a_col > b_col then return false end

  return tostring(a) < tostring(b)
end

H.error = function(msg) vim.notify(msg, vim.log.levels.ERROR) end

return M
