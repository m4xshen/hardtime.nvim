local highlights = require("hardtime.ui.highlights")

local M = {}

function M.render_title(title, bufnr)
   local buf_width = vim.api.nvim_win_get_width(0)

   local indent_length = math.floor((buf_width - #title) / 2)

   local indent = string.rep(" ", indent_length)

   vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { indent .. title })

   vim.api.nvim_buf_add_highlight(
      bufnr,
      0,
      highlights.title_highlight,
      0,
      indent_length,
      indent_length + #title
   )
end

function M.render_report(reports, bufnr)
   local hints = {}

   for index, report in ipairs(reports) do
      local repetition = " (" .. report[2] .. ")"
      local hint = index .. ". " .. report[1] .. repetition
      table.insert(hints, hint)
   end

   vim.api.nvim_buf_set_lines(bufnr, 6, -1, false, hints)
end

local function find_highlighted_indexes(tabs)
   local result = {}

   local start = 0

   for i = 1, #tabs do
      local ending = start + #tabs[i]
      table.insert(result, { start, ending })
      start = ending + 1
   end

   return result
end

function M.render_tabs(tabs, picked_tab_idx, bufnr)
   highlights.init()

   vim.api.nvim_buf_set_lines(
      bufnr,
      2,
      2,
      false,
      { table.concat(tabs, " ") }
   )

   local indexes = find_highlighted_indexes(tabs)

   for i, indices in ipairs(indexes) do
      local start_index = indices[1]
      local end_index = indices[2]

      if i == picked_tab_idx then
         vim.api.nvim_buf_add_highlight(
            bufnr,
            2,
            highlights.report_tab_focused,
            2,
            start_index,
            end_index
         )
      else
         vim.api.nvim_buf_add_highlight(
            bufnr,
            2,
            highlights.report_tab_unfocused,
            2,
            start_index,
            end_index
         )
      end
   end
end

return M
