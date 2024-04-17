local styles = require("hardtime.ui.styles")

local M = {}

function M.render_title(title, bufnr)
   title = styles.add_text_indent(title)
   local buf_width = vim.api.nvim_win_get_width(0)
   local indent_length = math.floor((buf_width - #title) / 2)
   local indent = string.rep(" ", indent_length)

   vim.api.nvim_buf_set_lines(bufnr, 1, 1, false, { indent .. title .. indent })

   vim.api.nvim_buf_add_highlight(
      bufnr,
      1,
      styles.title_highlight,
      1,
      indent_length,
      indent_length + #title
   )
end

function M.spacer(bufnr)
   vim.api.nvim_buf_set_lines(bufnr, 5, 5, false, { "" })
end

--- @param content table<string,string>
function M.render_hints(content, bufnr)
   local hints = {}

   for i, val in ipairs(content) do
      local num = i .. ". "
      local repetition = " (" .. val[2] .. ")"
      local hint = styles.add_content_indent() .. num .. val[1] .. repetition

      table.insert(hints, hint)
   end

   vim.api.nvim_buf_set_lines(bufnr, 6, 5, false, hints)
end

return M
