local _ = require("hardtime.ui.report_model")
local renderer = require("hardtime.ui.renderer")

local M = {}

local function render_content(reports, picked_tab, bufnr)
   vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

   local tabs = {}

   for _, report in ipairs(reports) do
      table.insert(tabs, report.tab)
   end

   renderer.render_title(" Hardtime Report ", bufnr)

   renderer.render_tabs(tabs, picked_tab, bufnr)

   vim.api.nvim_buf_set_lines(bufnr, 5, 5, false, { "" })

   renderer.render_report(reports[picked_tab].report, bufnr)

   vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

local function add_keybinds(reports, bufnr)
   for index, report in ipairs(reports) do
      vim.keymap.set("n", report.keybind, function()
         render_content(reports, index, bufnr)
      end, {
         buffer = bufnr,
         nowait = true,
         silent = true,
      })
   end
end

local is_open = false

function M.open(reports, initial_tab)
   if is_open then
      return
   end

   local Popup = require("nui.popup")

   local popup = Popup({
      enter = true,
      focusable = true,
      position = "50%",
      size = {
         width = "60%",
         height = "70%",
      },
      border = {
         padding = {
            left = 2,
            right = 2,
         },
      },
      relative = "editor",
   })

   popup:mount()
   is_open = true

   vim.keymap.set("n", "q", function()
      is_open = false
      popup:unmount()
   end, {
      buffer = popup.bufnr,
      nowait = true,
      silent = true,
   })

   add_keybinds(reports, popup.bufnr)

   popup:on("BufWinLeave", function()
      is_open = false
   end)

   render_content(reports, initial_tab, popup.bufnr)
   vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
end

return M
