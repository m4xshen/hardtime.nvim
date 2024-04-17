local styles = require("hardtime.ui.styles")
local M = {}

--- @param tabs table<string>
--- @param indent number
--- @return table
local function find_highlight_indexes(tabs, indent)
   local result = {}

   local start = indent

   for i = 1, #tabs do
      local _end = start + #tabs[i]
      table.insert(result, { start, _end })
      start = _end + 1
   end

   return result
end

--- @param tabs table<string>
--- @param picked_tab_idx number
function M.render_tabs(tabs, picked_tab_idx, bufnr)
   styles.init_highlights()

   tabs = styles.add_tab_indent(tabs)

   local buffer_indent_spaces = styles.add_content_indent()

   vim.api.nvim_buf_set_lines(
      bufnr,
      2,
      2,
      false,
      { buffer_indent_spaces .. table.concat(tabs, " ") }
   )

   local indexes = find_highlight_indexes(tabs, #buffer_indent_spaces)

   for i, indices in ipairs(indexes) do
      local start_index = indices[1]
      local end_index = indices[2]

      if i == picked_tab_idx then
         vim.api.nvim_buf_add_highlight(
            bufnr,
            2,
            styles.report_tab_focused,
            2,
            start_index,
            end_index
         )
      else
         vim.api.nvim_buf_add_highlight(
            bufnr,
            3,
            styles.report_tab_unfocused,
            2,
            start_index,
            end_index
         )
      end
   end
end

return M
