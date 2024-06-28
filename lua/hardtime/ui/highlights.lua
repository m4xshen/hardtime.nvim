local M = {}

M.report_tab_focused = "ReportTabFocused"
M.report_tab_unfocused = "ReportTabUnfocused"
M.title_highlight = "TitleHighlight"

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

function M.init()
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

return M
