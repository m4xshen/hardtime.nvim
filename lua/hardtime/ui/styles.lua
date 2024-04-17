local M = {}

M.report_tab_focused = "ReportTabFocused"
M.report_tab_unfocused = "ReportTabUnfocused"
M.title_highlight = "TitleHighlight"

local content_indent = 2

local tab_indent = 1

local hl_groups = {
   report_tab_unfocused = {
      name = M.report_tab_unfocused,
      bg = "#888888",
      fg = "#222222",
      default = true,
   },
   report_tab_focused = {
      name = M.report_tab_focused,
      bg = "#ABE9B3",
      fg = "#222222",
      default = true,
   },
   title_highlight = {
      name = M.title_highlight,
      bg = "#6C8EBF",
      fg = "#222222",
      default = true,
   },
}

function M.init_highlights()
   for _, hl in pairs(hl_groups) do
      local command = "highlight "
         .. hl.name
         .. " guifg="
         .. hl.fg
         .. " guibg="
         .. hl.bg
      vim.api.nvim_command(command)
   end
end

--- @param tabs table<string>
--- @return table<string>
function M.add_tab_indent(tabs)
   local indented_tabs = {}

   for _, tab in ipairs(tabs) do
      local indented_tab = M.add_text_indent(tab)
      table.insert(indented_tabs, indented_tab)
   end

   return indented_tabs
end

--- @return string
function M.add_content_indent()
   return string.rep(" ", content_indent)
end

--- @param text string
--- @return string
function M.add_text_indent(text)
   local indent = string.rep(" ", tab_indent)
   return indent .. text .. indent
end

return M
